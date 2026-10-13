class JC4MPBridge {
    constructor() {
        this.messageHandlers = new Map();
        this.isInitialized = false;
        this.initializationInterval = null;
        this.statusChangeHandlers = [];
        this.startedAt = Date.now();
        this.diagnosticLogged = false;
        this.startInitialization();
    }
    startInitialization() {
        // Clear any existing interval
        if (this.initializationInterval) {
            clearInterval(this.initializationInterval);
        }
        // Check immediately
        this.checkAndInitialize();
        // Set up continuous checking
        this.initializationInterval = setInterval(() => {
            this.checkAndInitialize();
        }, 500); // Check every 500ms
    }
    checkAndInitialize() {
        const wasInitialized = this.isInitialized;
        if (typeof window !== 'undefined' && window.JC4MP && !this.isInitialized) {
            // Set up the global message handler
            window.JC4MP.onMessage = (event, data) => {
                this.handleMessage(event, data);
            };
            this.isInitialized = true;
            console.log('JC4MP bridge initialized', this.getDiagnostics());
            // Stop continuous checking once initialized
            if (this.initializationInterval) {
                clearInterval(this.initializationInterval);
                this.initializationInterval = null;
            }
            // Notify status change handlers
            this.notifyStatusChange(true);
        }
        else if (typeof window !== 'undefined' && !window.JC4MP && this.isInitialized) {
            // JC4MP became unavailable
            this.isInitialized = false;
            console.log('JC4MP bridge disconnected');
            // Restart continuous checking
            this.startInitialization();
            // Notify status change handlers
            this.notifyStatusChange(false);
        }
        else if (!this.isInitialized && !this.diagnosticLogged && Date.now() - this.startedAt > 3000) {
            this.diagnosticLogged = true;
            console.warn('JC4MP bridge still unavailable', this.getDiagnostics());
        }
    }
    getDiagnostics() {
        if (typeof window === 'undefined') {
            return { window: false };
        }
        const read = (getter) => {
            try {
                return getter();
            }
            catch (error) {
                return `error:${error && error.name ? error.name : 'unknown'}`;
            }
        };
        const frameElement = read(() => window.frameElement);
        return {
            href: read(() => window.location.href),
            origin: read(() => window.location.origin),
            readyState: read(() => document.readyState),
            topLevel: read(() => window.top === window),
            windowName: read(() => window.name || ''),
            frameElementName: frameElement && typeof frameElement === 'object' ? read(() => frameElement.name || '') : '',
            frameElementSrc: frameElement && typeof frameElement === 'object' ? read(() => frameElement.getAttribute('src') || '') : '',
            hasJC4MP: !!window.JC4MP,
            hasNativeSend: typeof window.__JC4MPNativeSend === 'function',
            userAgent: read(() => navigator.userAgent)
        };
    }
    notifyStatusChange(available) {
        this.statusChangeHandlers.forEach(handler => {
            try {
                handler(available);
            }
            catch (error) {
                console.error('Error in JC4MP status change handler:', error);
            }
        });
    }
    handleMessage(event, data) {
        const handlers = this.messageHandlers.get(event);
        if (handlers) {
            handlers.forEach(handler => {
                try {
                    handler(data);
                }
                catch (error) {
                    console.error(`Error in JC4MP message handler for event ${event}:`, error);
                }
            });
        }
    }
    // Add event listener for specific events
    on(event, callback) {
        if (!this.messageHandlers.has(event)) {
            this.messageHandlers.set(event, []);
        }
        this.messageHandlers.get(event).push(callback);
    }
    // Remove event listener
    off(event, callback) {
        const handlers = this.messageHandlers.get(event);
        if (handlers) {
            const index = handlers.indexOf(callback);
            if (index > -1) {
                handlers.splice(index, 1);
            }
        }
    }
    // Listen for JC4MP availability changes
    onStatusChange(callback) {
        this.statusChangeHandlers.push(callback);
    }
    // Remove status change listener
    offStatusChange(callback) {
        const index = this.statusChangeHandlers.indexOf(callback);
        if (index > -1) {
            this.statusChangeHandlers.splice(index, 1);
        }
    }
    // Cleanup method
    destroy() {
        if (this.initializationInterval) {
            clearInterval(this.initializationInterval);
            this.initializationInterval = null;
        }
        this.messageHandlers.clear();
        this.statusChangeHandlers.length = 0;
    }
    // Send message to Lua
    sendMessage(event, data = null) {
        if (this.isAvailable()) {
            try {
                window.JC4MP.sendMessage(event, data);
            }
            catch (error) {
                console.error('Failed to send JC4MP message:', error);
            }
        }
        else {
            console.warn('JC4MP not available, cannot send message:', event);
        }
    }
    // Check if JC4MP is available
    isAvailable() {
        return this.isInitialized &&
            typeof window !== 'undefined' &&
            !!window.JC4MP &&
            typeof window.JC4MP.sendMessage === 'function';
    }
    // Chat-specific methods
    sendChatMessage(message) {
        this.sendMessage('chat_message', { message: message.trim() });
    }
    sendChatCommand(command, args) {
        this.sendMessage('chat_command', { command, args });
    }
    enableChatInput() {
        this.sendMessage('enable_chat_input');
    }
    disableChatInput() {
        this.sendMessage('disable_chat_input');
    }
    requestInputFocus() {
        this.sendMessage('request_input_focus');
    }
}
export const jc4mp = new JC4MPBridge();
//# sourceMappingURL=jc4mp.js.map
