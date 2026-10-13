declare global {
    interface Window {
        JC4MP: {
            sendMessage: (event: string, data: any) => void;
            onMessage?: (event: string, data: any) => void;
            on?: (event: string, callback: (data: any) => void) => void;
            isAvailable?: () => boolean;
        };
    }
}
declare class JC4MPBridge {
    private messageHandlers;
    private isInitialized;
    private initializationInterval;
    private statusChangeHandlers;
    constructor();
    private startInitialization;
    private checkAndInitialize;
    private notifyStatusChange;
    private handleMessage;
    on(event: string, callback: (data: any) => void): void;
    off(event: string, callback: (data: any) => void): void;
    onStatusChange(callback: (available: boolean) => void): void;
    offStatusChange(callback: (available: boolean) => void): void;
    destroy(): void;
    sendMessage(event: string, data?: any): void;
    isAvailable(): boolean;
    sendChatMessage(message: string): void;
    sendChatCommand(command: string, args: string[]): void;
    enableChatInput(): void;
    disableChatInput(): void;
    requestInputFocus(): void;
}
export declare const jc4mp: JC4MPBridge;
export {};
