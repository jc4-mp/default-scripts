const spawnlist = {
    categories: [
        {
            name: "Vehicles",
            type: "parent",
            subcategories: [
                {
                    name: "Land",
                    type: "vehicle",
                    items: [
                        {
                            separator: true,
                            name: "Civilian"
                        },
                        {
                            name: "Prisa Temerario ATV",
                            id: "v000_car_atv_civilian_01"
                        },
                        {
                            name: "Pugilista SUV",
                            id: "v002_car_vintagesuv_civilian"
                        },
                        {
                            name: "Ritmo Rickshaw",
                            id: "v008_car_taxitrike_civilian"
                        },
                        {
                            name: "Cadadía '83 Hatchback",
                            id: "v011_car_oldtwodoorhatch_civilian_01"
                        },
                        {
                            name: "Coyle Mambo",
                            id: "v017_car_vintagemuscle_civilian"
                        },
                        {
                            name: "Coyle Mambo (Black, unused)",
                            id: "v017_car_vintagemuscle_civilian_02"
                        },
                        {
                            name: "Chupacabra",
                            id: "v018_car_monstertruck_civilian_01"
                        },
                        {
                            name: "Kerner Charmant Limo",
                            id: "v019_car_modernlimo_civilian_01"
                        },
                        {
                            name: "Kerner '16 Vigeur",
                            id: "v020_car_moderngrandtourer_civilian_01"
                        },
                        {
                            name: "Kerner Serpente S",
                            id: "v021_car_sportsmuscle_civilian_01"
                        },
                        {
                            name: "Mugello Farina Trio",
                            id: "v022_car_moderncircuitracer_civilian_01"
                        },
                        {
                            name: "2019 Vistosa Supercar",
                            id: "v023_car_racingsuper_civilian_01"
                        },
                        {
                            name: "2019 Vistosa Supercar (Racing, unused)",
                            id: "v023_car_racingsuper_racing_01"
                        },
                        {
                            name: "Verdeleon Eco",
                            id: "v024_car_ecosuper_civilian_01"
                        },
                        {
                            name: "Verdeleon Eco (Racing, unused)",
                            id: "v024_car_ecosuper_racing_01"
                        },
                        {
                            name: "Mugello Quipozza G",
                            id: "v025_car_vintagesuper_civilian_01"
                        },
                        {
                            name: "'69 Mugello Raffinati",
                            id: "v026_car_vintagesports_civilian_01"
                        },
                        {
                            name: "Verdad 1 Stormchaser",
                            id: "v027_car_hurricanetruck_civilian"
                        },
                        {
                            name: "Cúmbila Sedan",
                            id: "v029_car_smallmodernsedan_civilian_01"
                        },
                        {
                            name: "Cúmbila Sedan (Scratched)",
                            id: "v029_car_smallmodernsedan_civilian_02"
                        },
                        {
                            name: "Prisa Fresca",
                            id: "v030_car_oldmini_civilian_01"
                        },
                        {
                            name: "Prisa Rayo Sport",
                            id: "v031_car_racinghothatch_civilian_01"
                        },
                        {
                            name: "Prisa Rayo Sport (Takedown)",
                            id: "v031_car_racingshothatch_encounter_takedown"
                        },
                        {
                            name: "Sol 21 Sport Sedan",
                            id: "v032_car_luxurysportssedan_civilian_01"
                        },
                        {
                            name: "Prisa Fresca X",
                            id: "v033_car_modernmini_civilian_01"
                        },
                        {
                            name: "Pasofino Pickup",
                            id: "v036_car_modernpickup_civilian_01"
                        },
                        {
                            name: "Prisa Viento SUV",
                            id: "v038_car_modernsuv_civilian_01"
                        },
                        {
                            name: "Caravana Camper",
                            id: "v039_car_oldcampervan_civilian_01"
                        },
                        {
                            name: "Prisa Hidalgo",
                            id: "v040_car_oldcompact_civilian_01"
                        },
                        {
                            name: "Prisa Azor 3",
                            id: "v042_car_racingsedan_civilian"
                        },
                        {
                            name: "Prisa Azor 3 (Racing, unused)",
                            id: "v042_car_racingsedan_racing_01"
                        },
                        {
                            name: "Vagabundo Buggy",
                            id: "v046_car_racingbuggy_civilian"
                        },
                        {
                            name: "Vagabundo Buggy (Racing, unused)",
                            id: "v046_car_racingbuggy_racing_01"
                        },
                        {
                            name: "Toy Offroader",
                            id: "v050_car_toyjeep_civilian"
                        },
                        {
                            separator: true,
                            name: "Special"
                        },
                        {
                            name: "Alpinista Snowmobile",
                            id: "v804_treaded_snowmobile_civilian"
                        },
                        {
                            name: "Alpinista Snowmobile (Mission)",
                            id: "v804_treaded_snowmobile_civilian_mission_special"
                        },
                        {
                            separator: true,
                            name: "Commercial"
                        },
                        {
                            name: "Camión Truck",
                            id: "v004_car_articulatedtruck_commercial_01"
                        },
                        {
                            name: "Forzudo Armored Van",
                            id: "v009_car_armoredtruck_commercial_01"
                        },
                        {
                            name: "Ranchero Truck",
                            id: "v034_car_oldtruck_commercial_01"
                        },
                        {
                            name: "Prisa Calzada Van Truck",
                            id: "v035_car_modernvan_civic_ambulance_01"
                        },
                        {
                            name: "Calzada Ambulancia",
                            id: "v035_car_modernvan_commercial_01"
                        },
                        {
                            name: "Prisa Viajero Bus",
                            id: "v037_car_modernbus_commercial_01"
                        },
                        {
                            name: "Car Trailer",
                            id: "v901_trailer_cartransport_commercial"
                        },
                        {
                            separator: true,
                            name: "Industrial"
                        },
                        {
                            name: "Armadillo Forklift",
                            id: "v001_car_forklift_industrial"
                        },
                        {
                            name: "Armadillo Crane Truck",
                            id: "v003_car_crane_industrial"
                        },
                        {
                            name: "Wheel Loader",
                            id: "v005_car_wheelloader_industrial"
                        },
                        {
                            name: "Banda Conveyor",
                            id: "v006_car_conveyorcrane_industrial"
                        },
                        {
                            name: "Modelo 4 Tractor",
                            id: "v010_car_oldtractor_civilian_01"
                        },
                        {
                            name: "Armadillo 9M",
                            id: "v045_car_minetruck_commercial_01"
                        },
                        {
                            name: "Flatbed Trailer",
                            id: "v902_trailer_lowloader_commercial"
                        },
                        {
                            name: "Flatbed Trailer with Radar (Folded)",
                            id: "v902_trailer_lowloader_mobile_radar_folded"
                        },
                        {
                            name: "Flatbed Trailer with Radar (Extended)",
                            id: "v902_trailer_lowloader_mobile_radar_upright"
                        },
                        {
                            name: "Cargo Trailer",
                            id: "v903_trailer_cargo_commercial"
                        },
                        {
                            separator: true,
                            name: "Black Hand"
                        },
                        {
                            name: "Reptile AAV",
                            id: "v012_car_apc_military_01"
                        },
                        {
                            name: "Cavalry Armored Truck",
                            id: "v013_car_armoredtransport_military_01"
                        },
                        {
                            name: "Warrior Offroader",
                            id: "v014_car_offroadtruck_military_01"
                        },
                        {
                            name: "Longbow Cannon Truck",
                            id: "v015_car_cannontruck_military"
                        },
                        {
                            name: "Prospero Hauler",
                            id: "v016_car_armoredarticulatedtruck_military"
                        },
                        {
                            name: "Prospero Hauler With Generator",
                            id: "v016_car_armoredarticulatedtruck_military_generator"
                        },
                        {
                            name: "Vagabundo Buggy (Military)",
                            id: "v046_car_racingbuggy_military"
                        },
                        {
                            name: "Prospero Hunter Bike",
                            id: "v301_bike_combatdirt_military_01"
                        },
                        {
                            name: "Warchief Assault Tank",
                            id: "v800_treaded_modernheavytank_military_01"
                        },
                        {
                            name: "Prizefighter Tank",
                            id: "v801_treaded_mediumtank_military_01"
                        },
                        {
                            name: "Falconer AA Tank",
                            id: "v802_treaded_aatank_military"
                        },
                        {
                            name: "Pointman Scout Tank",
                            id: "v803_treaded_flexturrettank_military"
                        },
                        {
                            name: "Huntsman SAM Launcher",
                            id: "v904_trailer_smallmobileweapon_military"
                        },
                        {
                            name: "Prospero Signal Jammer",
                            id: "v907_trailer_radarjammer_military"
                        },
                        {
                            separator: true,
                            name: "Missions"
                        },
                        {
                            name: "Ion Coil Stormchaser",
                            id: "v027_car_hurricanetruck_tesla"
                        },
                        {
                            name: "Tied Down Ion Coil Stormchaser",
                            id: "v027_car_hurricanetruck_transport"
                        },
                        {
                            name: "Ranchero Truck With Weapon Shipment Box",
                            id: "v034_car_oldtruck_commercial_cargo_sargento_intro"
                        },
                        {
                            separator: true,
                            name: "Rebels"
                        },
                        {
                            name: "Pugilista SUV",
                            id: "v002_car_vintagesuv_rebel"
                        },
                        {
                            name: "Reptile AAV",
                            id: "v012_car_apc_rebel_01"
                        },
                        {
                            name: "Cavalry Armored Truck",
                            id: "v013_car_armoredtransport_rebel_01"
                        },
                        {
                            name: "Warrior Offroader",
                            id: "v014_car_offroadtruck_rebel_01"
                        },
                        {
                            name: "Longbow Cannon Truck",
                            id: "v015_car_cannontruck_rebel"
                        },
                        {
                            name: "Prospero Hauler",
                            id: "v016_car_armoredarticulatedtruck_rebel"
                        },
                        {
                            name: "Prospero Hunter Bike",
                            id: "v301_bike_combatdirt_rebel_01"
                        },
                        {
                            name: "Warchief Assault Tank",
                            id: "v800_treaded_modernheavytank_rebel_01"
                        },
                        {
                            name: "Prizefighter Tank",
                            id: "v801_treaded_mediumtank_rebel_01"
                        },
                        {
                            name: "Falconer AA Tank",
                            id: "v802_treaded_aatank_rebel"
                        },
                        {
                            name: "Pointman Scout Tank",
                            id: "v803_treaded_flexturrettank_rebel"
                        },
                        {
                            name: "Huntsman SAM Launcher",
                            id: "v904_trailer_smallmobileweapon_rebel"
                        },
                        {
                            separator: true,
                            name: "Backers"
                        },
                        {
                            name: "Prisa Temerario ATV",
                            id: "v000_car_atv_javi"
                        },
                        {
                            name: "Cadadía '83 Hatchback",
                            id: "v011_car_oldtwodoorhatch_sargento"
                        },
                        {
                            name: "Garland King Studios Van",
                            id: "v035_car_modernvan_garland"
                        },
                        {
                            name: "Prisa Hidalgo",
                            id: "v040_car_oldcompact_sargento"
                        },
                        {
                            name: "Prisa Maradona Z",
                            id: "v308_bike_trials_javi"
                        },
                        {
                            separator: true,
                            name: "Rigged"
                        },
                        {
                            name: "Rigged Coyle Mambo",
                            id: "v017_car_vintagemuscle_bomb_special"
                        },
                        {
                            name: "Rigged Chupacabra",
                            id: "v018_car_monstertruck_bomb_special"
                        },
                        {
                            name: "Rigged Charmant Limo",
                            id: "v019_car_modernlimo_bomb_special"
                        },
                        {
                            name: "Rigged Serpente S",
                            id: "v021_car_sportsmuscle_bomb_special"
                        },
                        {
                            name: "Rigged Mugello Farina Trio",
                            id: "v022_car_moderncircuitracer_bomb_special"
                        },
                        {
                            name: "Rigged Mugello Vistosa",
                            id: "v023_car_racingsuper_bomb_special"
                        },
                        {
                            name: "Rigged Verdeleon Eco",
                            id: "v024_car_ecosuper_bomb_special"
                        },
                        {
                            name: "Rigged Quipozza G",
                            id: "v025_car_vintagesuper_bomb_special"
                        },
                        {
                            name: "Rigged Raffinati",
                            id: "v026_car_vintagesports_bomb_special"
                        },
                        {
                            name: "Rigged Mugello V405",
                            id: "v303_bike_modernsuper_bomb_special"
                        },
                        {
                            name: "Rigged Furia Bike",
                            id: "v304_bike_modernsport_bomb_special"
                        },
                    ]
                },
                {
                    name: "Bikes",
                    type: "vehicle",
                    items: [
                        {
                            separator: true,
                            name: "Civilian"
                        },
                        {
                            name: "Mugello V405 Bike",
                            id: "v303_bike_modernsuper_civilian_01"
                        },
                        {
                            name: "Furia Sportbike",
                            id: "v304_bike_modernsport_civilian_01"
                        },
                        {
                            name: "Prisa X-2 Bike",
                            id: "v305_bike_oldroad_civilian_01"
                        },
                        {
                            name: "Prisa Viveza Bike",
                            id: "v306_bike_modernroad_civilian_01"
                        },
                        {
                            name: "Prisa Tía Moped",
                            id: "v307_bike_oldmoped_civilian_01"
                        },
                        {
                            name: "Prisa Maradona Z",
                            id: "v308_bike_trials_civilian_01"
                        },
                    ]
                },
                {
                    name: "Helis",
                    type: "vehicle",
                    items: [
                        {
                            separator: true,
                            name: "Civilian"
                        },
                        {
                            name: "Emvasion Utility Heli",
                            id: "v205_helicopter_utility_civilian_01"
                        },
                        {
                            name: "Emvasion News Heli",
                            id: "v205_helicopter_utility_commercial_news"
                        },
                        {
                            name: "Emvasion Float Heli",
                            id: "v206_helicopter_bubblescout_civilian_01"
                        },
                        {
                            separator: true,
                            name: "Cinematics"
                        },
                        {
                            name: "Dropzone Helicopter (Black Hand)",
                            id: "v202_helicopter_heavytroop_gabriela"
                        },
                        {
                            name: "Dropzone Helicopter (Rebel)",
                            id: "v202_helicopter_heavytroop_mira"
                        },
                        {
                            separator: true,
                            name: "Black Hand"
                        },
                        {
                            name: "Prospero Sky Crane",
                            id: "v200_helicopter_heavylift_military"
                        },
                        {
                            name: "Spectre Attack Heli",
                            id: "v201_helicopter_mediumattack_military_01"
                        },
                        {
                            name: "Dropzone Chopper",
                            id: "v202_helicopter_heavytroop_military_01"
                        },
                        {
                            name: "Firebrand Scout Chopper",
                            id: "v203_helicopter_lightattack_military_01"
                        },
                        {
                            name: "Bloodhound Siege Heli",
                            id: "v204_helicopter_heavyassault_military_01"
                        },
                        {
                            separator: true,
                            name: "Rebels"
                        },
                        {
                            name: "Prospero Sky Crane",
                            id: "v200_helicopter_heavylift_rebel_01"
                        },
                        {
                            name: "Spectre Attack Heli",
                            id: "v201_helicopter_mediumattack_rebel_01"
                        },
                        {
                            name: "Dropzone Chopper",
                            id: "v202_helicopter_heavytroop_rebel_01"
                        },
                        {
                            name: "Firebrand Scout Chopper",
                            id: "v203_helicopter_lightattack_rebel_01"
                        },
                        {
                            name: "Bloodhound Siege Heli",
                            id: "v204_helicopter_heavyassault_rebel_01"
                        },
                    ]
                },
                {
                    name: "Planes",
                    type: "vehicle",
                    items: [
                        {
                            separator: true,
                            name: "Civilian"
                        },
                        {
                            name: "Emvasion Float Heli",
                            id: "v206_helicopter_bubblescout_civilian_01"
                        },
                        {
                            name: "EM-909 Private Jet",
                            id: "v404_plane_privatejet_civilian"
                        },
                        {
                            name: "EM-979 Airliner",
                            id: "v405_plane_commercialcargo_commercial"
                        },
                        {
                            name: "Emvasion Floatplane",
                            id: "v406_plane_smallprop_civilian_01"
                        },
                        {
                            name: "Emvasion Cropduster",
                            id: "v407_plane_mediumprop_civilian_01"
                        },
                        {
                            name: "Ultralight",
                            id: "v408_plane_ultralight_civilian"
                        },
                        {
                            name: "Emvasion Airship",
                            id: "v700_balloon_dirigible_civilian"
                        },
                        {
                            separator: true,
                            name: "Collectible"
                        },
                        {
                            name: "Emvasion Airship",
                            id: "v700_balloon_dirigible_collectible"
                        },
                        {
                            separator: true,
                            name: "Black Hand"
                        },
                        {
                            name: "Fellhawk Jet Fighter",
                            id: "v400_plane_fighterjet_military_01"
                        },
                        {
                            name: "Skycastle Cargo Jet",
                            id: "v401_plane_cargotransport_military_01"
                        },
                        {
                            name: "Skycastle Cargo Jet",
                            id: "v401_plane_cargotransport_military_01_paratrooper"
                        },
                        {
                            name: "Thunderhead Bomber Jet",
                            id: "v402_plane_fighterbomber_military_01"
                        },
                        {
                            name: "PA Microfighter",
                            id: "v403_plane_microjet_military"
                        },
                        {
                            name: "Emvasion Airship",
                            id: "v700_balloon_dirigible_military_01"
                        },
                        {
                            separator: true,
                            name: "Rebels"
                        },
                        {
                            name: "Fellhawk Jet Fighter",
                            id: "v400_plane_fighterjet_rebel_01"
                        },
                        {
                            name: "Skycastle Cargo Jet",
                            id: "v401_plane_cargotransport_rebel_01"
                        },
                        {
                            name: "Thunderhead Bomber Jet",
                            id: "v402_plane_fighterbomber_rebel_01"
                        },
                        {
                            name: "PA Microfighter",
                            id: "v403_plane_microjet_rebel"
                        },
                    ]
                },
                {
                    name: "Boats",
                    type: "vehicle",
                    items: [
                        {
                            separator: true,
                            name: "Civilian"
                        },
                        {
                            name: "Dondequiera Fanboat",
                            id: "v100_boat_fanboat_civilian"
                        },
                        {
                            name: "Kerner Brise 42",
                            id: "v105_boat_sailboat_civilian_01"
                        },
                        {
                            name: "Dame De La Mer Yacht",
                            id: "v106_boat_motoryacht_civilian_01"
                        },
                        {
                            name: "Mugello Pescespada SX",
                            id: "v107_boat_racingboat_civilian_01"
                        },
                        {
                            name: "Fishing Boat",
                            id: "v108_boat_largeoldfishing_civilian_01"
                        },
                        {
                            name: "Prisa Chapoteo",
                            id: "v110_boat_jetski_civilian_01"
                        },
                        {
                            separator: true,
                            name: "Commercial"
                        },
                        {
                            name: "Barco Roro Ferry",
                            id: "v109_boat_ferry_commercial"
                        },
                        {
                            separator: true,
                            name: "Black Hand"
                        },
                        {
                            name: "Daggershark Jetboat",
                            id: "v101_boat_smalljet_military"
                        },
                        {
                            name: "Stromwater Patrol Boat",
                            id: "v102_boat_heavypatrol_military_01"
                        },
                        {
                            name: "Conquistador Warship",
                            id: "v103_boat_corvette_military_01"
                        },
                        {
                            name: "Spearhead Transport",
                            id: "v104_boat_landingtransport_commercial"
                        },
                        {
                            separator: true,
                            name: "Missions (may crash)"
                        },
                        {
                            name: "Thunderbarge",
                            id: "v102_boat_heavypatrol_lightning"
                        },
                        {
                            name: "Spearhead Transport",
                            id: "v104_boat_landingtransport_commercial_lightningrod_escort"
                        },
                        {
                            name: "Spearhead Transport With Signal Jammer",
                            id: "v104_boat_landingtransport_commercial_signal_jammer"
                        },
                        {
                            name: "Fishing Boat",
                            id: "v108_boat_largeoldfishing_civilian_01_garland_intro"
                        },
                        {
                            separator: true,
                            name: "Rebels"
                        },
                        {
                            name: "Daggershark Jetboat",
                            id: "v101_boat_smalljet_rebel"
                        },
                        {
                            name: "Stromwater Patrol Boat",
                            id: "v102_boat_heavypatrol_rebel_01"
                        },
                        {
                            name: "Conquistador Warship",
                            id: "v103_boat_corvette_rebel_01"
                        },
                        {
                            name: "Spearhead Transport",
                            id: "v104_boat_landingtransport_commercial_rebel"
                        },
                        {
                            separator: true,
                            name: "Rigged"
                        },
                        {
                            name: "Rigged Dame de la Mer",
                            id: "v106_boat_motoryacht_bomb_special"
                        },
                        {
                            name: "Rigged Pescespada SX",
                            id: "v107_boat_racingboat_bomb_special"
                        },
                    ]
                },
                {
                    name: "DLC",
                    type: "vehicle",
                    items: [
                        {
                            separator: true,
                            name: "Agency DLC"
                        },
                        {
                            name: "Agency Spy Helicopter",
                            id: "v221_helicopter_agencyspy_agency"
                        },
                        {
                            name: "Agency Spy Boat",
                            id: "v123_boat_agencyspy_agency"
                        },
                        {
                            name: "Agency Hovercraft",
                            id: "v851_car_hovercraft_agency"
                        },
                        {
                            name: "Agency Hovercraft (Mission)",
                            id: "v851_car_hovercraft_agency_mission_special_dlc3_outro"
                        },
                        {
                            name: "Pugilista SUV (Mission)",
                            id: "v002_car_vintagesuv_rebel_mission_special_dlc3_intro"
                        },
                        {
                            separator: true,
                            name: "Dare Devils of Destruction"
                        },
                        {
                            name: "Reptile AAV (Daredevil)",
                            id: "v012_car_apc_daredevil"
                        },
                        {
                            name: "Battle Muscle",
                            id: "v051_car_battlemuscle_daredevil"
                        },
                        {
                            name: "Battle Muscle (Metal)",
                            id: "v051_car_battlemuscle_metal01"
                        },
                        {
                            name: "Battle Muscle (Rust)",
                            id: "v051_car_battlemuscle_rust01"
                        },
                        {
                            name: "Battle Muscle (Stripe 1)",
                            id: "v051_car_battlemuscle_stripe01"
                        },
                        {
                            name: "Battle Muscle (Stripe 2)",
                            id: "v051_car_battlemuscle_stripe02"
                        },
                        {
                            name: "Battle Muscle (Tiger)",
                            id: "v051_car_battlemuscle_tiger01"
                        },
                        {
                            name: "Battle Muscle (Base)",
                            id: "v051_car_battlemuscle_level_0"
                        },
                        {
                            name: "Offroad Truck Level 0",
                            id: "v070_car_offroadtruckdlc1_level_0"
                        },
                        {
                            name: "Offroad Truck Level 1",
                            id: "v070_car_offroadtruckdlc1_level_1"
                        },
                        {
                            name: "Offroad Truck Level 2",
                            id: "v070_car_offroadtruckdlc1_level_2"
                        },
                        {
                            name: "Offroad Truck Level 3",
                            id: "v070_car_offroadtruckdlc1_level_3"
                        },
                        {
                            name: "Modern Pickup Level 0",
                            id: "v071_car_modernpickupdlc1_level_0"
                        },
                        {
                            name: "Modern Pickup Level 1",
                            id: "v071_car_modernpickupdlc1_level_1"
                        },
                        {
                            name: "Modern Pickup Level 2",
                            id: "v071_car_modernpickupdlc1_level_2"
                        },
                        {
                            name: "Modern Pickup Level 3",
                            id: "v071_car_modernpickupdlc1_level_3"
                        },
                        {
                            name: "Vintage SUV Level 0",
                            id: "v072_car_vintagesuvdlc1_level_0"
                        },
                        {
                            name: "Vintage SUV Level 1",
                            id: "v072_car_vintagesuvdlc1_level_1"
                        },
                        {
                            name: "Vintage SUV Level 2",
                            id: "v072_car_vintagesuvdlc1_level_2"
                        },
                        {
                            name: "Vintage SUV Level 3",
                            id: "v072_car_vintagesuvdlc1_level_3"
                        },
                        {
                            name: "Luxury Sports Sedan Level 0",
                            id: "v073_car_luxurysportssedandlc1_level_0"
                        },
                        {
                            name: "Luxury Sports Sedan Level 1",
                            id: "v073_car_luxurysportssedandlc1_level_1"
                        },
                        {
                            name: "Luxury Sports Sedan Level 2",
                            id: "v073_car_luxurysportssedandlc1_level_2"
                        },
                        {
                            name: "Luxury Sports Sedan Level 3",
                            id: "v073_car_luxurysportssedandlc1_level_3"
                        },
                        {
                            name: "Eco Super Level 0",
                            id: "v074_car_ecosuperdlc1_level_0"
                        },
                        {
                            name: "Eco Super Level 1",
                            id: "v074_car_ecosuperdlc1_level_1"
                        },
                        {
                            name: "Eco Super Level 2",
                            id: "v074_car_ecosuperdlc1_level_2"
                        },
                        {
                            name: "Eco Super Level 3",
                            id: "v074_car_ecosuperdlc1_level_3"
                        },
                        {
                            name: "Vintage Super Level 0",
                            id: "v075_car_vintagesuperdlc1_level_0"
                        },
                        {
                            name: "Vintage Super Level 1",
                            id: "v075_car_vintagesuperdlc1_level_1"
                        },
                        {
                            name: "Vintage Super Level 2",
                            id: "v075_car_vintagesuperdlc1_level_2"
                        },
                        {
                            name: "Vintage Super Level 3",
                            id: "v075_car_vintagesuperdlc1_level_3"
                        },
                        {
                            name: "Racing Buggy Level 0",
                            id: "v076_car_racingbuggydlc1_level_0"
                        },
                        {
                            name: "Racing Buggy Level 1",
                            id: "v076_car_racingbuggydlc1_level_1"
                        },
                        {
                            name: "Racing Buggy Level 2",
                            id: "v076_car_racingbuggydlc1_level_2"
                        },
                        {
                            name: "Racing Buggy Level 3",
                            id: "v076_car_racingbuggydlc1_level_3"
                        },
                        {
                            name: "Offroad Racing Sedan Level 0",
                            id: "v077_car_offroadracingsedandlc1_level_0"
                        },
                        {
                            name: "Offroad Racing Sedan Level 1",
                            id: "v077_car_offroadracingsedandlc1_level_1"
                        },
                        {
                            name: "Offroad Racing Sedan Level 2",
                            id: "v077_car_offroadracingsedandlc1_level_2"
                        },
                        {
                            name: "Offroad Racing Sedan Level 3",
                            id: "v077_car_offroadracingsedandlc1_level_3"
                        },
                        {
                            name: "Monster Truck Level 0",
                            id: "v078_car_monstertruckdlc1_level_0"
                        },
                        {
                            name: "Monster Truck Level 1",
                            id: "v078_car_monstertruckdlc1_level_1"
                        },
                        {
                            name: "Monster Truck Level 2",
                            id: "v078_car_monstertruckdlc1_level_2"
                        },
                        {
                            name: "Monster Truck Level 3",
                            id: "v078_car_monstertruckdlc1_level_3"
                        },
                        {
                            separator: true,
                            name: "Brawler Mech"
                        },
                        {
                            name: "Loader Mech",
                            id: "v600_mech_loader_garage"
                        },
                        {
                            separator: true,
                            name: "Shark & Bark Pack"
                        },
                        {
                            name: "Shark Car",
                            id: "v082_car_shark_garage"
                        },
                        {
                            name: "Dog Car",
                            id: "v083_car_dog_garage"
                        },
                        {
                            separator: true,
                            name: "Sea Dogs Pack"
                        },
                        {
                            name: "Galleon Float",
                            id: "v080_car_galleonfloat_garage"
                        },
                        {
                            name: "Armored Hovercraft",
                            id: "v850_car_hovercraft_armored_garage"
                        },
                        {
                            separator: true,
                            name: "Adversary Pack"
                        },
                        {
                            name: "VTOL Jet",
                            id: "v422_plane_vtoljet_garage"
                        },
                        {
                            name: "Interceptor",
                            id: "v081_car_interceptor"
                        },
                        {
                            separator: true,
                            name: "Soaring Speed Pack"
                        },
                        {
                            name: "Flying Car (Land)",
                            id: "v086_car_flyingcar_garage"
                        },
                        {
                            separator: true,
                            name: "Toy Vehicle Pack"
                        },
                        {
                            name: "Toy Patrol Boat",
                            id: "v122_boat_toypatrol_garage"
                        },
                        {
                            name: "Toy Bomber",
                            id: "v420_plane_toybomber_garage"
                        },
                        {
                            name: "Toy Tank",
                            id: "v820_treaded_toytank_garage"
                        },
                        {
                            separator: true,
                            name: "The Dragon Pack"
                        },
                        {
                            name: "Racing Buggy (Preorder)",
                            id: "v046_car_racingbuggy_preorder_01"
                        },
                        {
                            name: "Coyle Mambo (Rico)",
                            id: "v017_car_vintagemuscle_rico"
                        },
                        {
                            name: "PA Microfighter (Preorder)",
                            id: "v403_plane_microjet_preorder_01"
                        },
                        {
                            name: "Verdeleon Eco (Preorder)",
                            id: "v024_car_ecosuper_preorder_01"
                        },
                        {
                            name: "Hot Rod",
                            id: "v053_car_hotrod_garage"
                        },
                        {
                            name: "Hot Rod (Rat Rod)",
                            id: "v053_car_hotrod_ratrod"
                        },
                        {
                            name: "Ice Cream Truck",
                            id: "v084_car_icecreamtruck_garage"
                        },
                        {
                            name: "Duck Boat",
                            id: "v117_boat_duck_garage"
                        }
                    ]
                }
            ]
        },
        {
            name: "Weapons",
            type: "weapon",
            items: [
                {
                    separator: true,
                    name: "Main"
                },
                {
                    name: "Assault Rifle",
                    id: "wpn_000_assault_rifle"
                },
                {
                    name: "Assault Rifle Mk II",
                    id: "wpn_001_assault_rifle"
                },
                {
                    name: "Assault Rifle Mk III",
                    id: "wpn_003_assault_rifle"
                },
                {
                    name: "Machine Gun",
                    id: "wpn_010_machinegun"
                },
                {
                    name: "Machine Gun Mk II",
                    id: "wpn_011_machinegun"
                },
                {
                    name: "Shotgun",
                    id: "wpn_020_shotgun"
                },
                {
                    name: "Shotgun Mk II",
                    id: "wpn_021_shotgun"
                },
                {
                    name: "Shotgun Mk III",
                    id: "wpn_022_shotgun"
                },
                {
                    name: "Sniper Rifle",
                    id: "wpn_030_sniper_rifle"
                },
                {
                    name: "Sniper Rifle Mk II",
                    id: "wpn_031_sniper_rifle"
                },
                {
                    name: "Sniper Rifle Mk III",
                    id: "wpn_032_sniper_rifle"
                },
                {
                    name: "Combat Rifle",
                    id: "wpn_040_combat_rifle"
                },
                {
                    name: "Submachine Gun (SMG)",
                    id: "wpn_050_smg"
                },
                {
                    name: "RPG Launcher",
                    id: "wpn_060_rpg"
                },
                {
                    name: "RPG Launcher Mk II",
                    id: "wpn_061_rpg"
                },
                {
                    name: "RPG Launcher Mk III",
                    id: "wpn_063_rpg"
                },
                {
                    name: "Grenade Launcher",
                    id: "wpn_070_glauncher"
                },
                {
                    name: "Missile Launcher",
                    id: "wpn_071_mlauncher"
                },
                {
                    name: "Experimental Weapon",
                    id: "wpn_080_experimental"
                },
                {
                    name: "Experimental Weapon Mk II",
                    id: "wpn_081_experimental"
                },
                {
                    name: "Railgun",
                    id: "wpn_100_railgun"
                },
                {
                    separator: true,
                    name: "Deathstalker DLC"
                },
                {
                    name: "Deathstalker Signature Rifle",
                    id: "wpn_901_signature_rifle"
                },
                {
                    separator: true,
                    name: "Golden Gear DLC"
                },
                {
                    name: "Golden Shotgun",
                    id: "wpn_902_golden_shotgun"
                },
                {
                    separator: true,
                    name: "The Dragon DLC"
                },
                {
                    name: "The Dragon",
                    id: "wpn_904_dragon"
                },
                {
                    separator: true,
                    name: "Legacy Pack DLC"
                },
                {
                    name: "Cluster Bomb",
                    id: "wpn_905_clusterbomb"
                },
                {
                    separator: true,
                    name: "Demons DLC"
                },
                {
                    name: "Crossbow",
                    id: "wpn_102_crossbow"
                },
                {
                    separator: true,
                    name: "Danger Rising DLC"
                },
                {
                    name: "Railgun (Miller)",
                    id: "wpn_100_railgun_miller"
                },
                {
                    name: "Agency Handcannon",
                    id: "wpn_450_agency_handcannon"
                },
                {
                    name: "Agency SMG",
                    id: "wpn_460_agency_smg"
                },
                {
                    name: "Magnesis",
                    id: "wpn_463_magnesis"
                },
            ]
        },
        {
            name: "Skins",
            type: "parent",
            subcategories: [
                {
                    name: "Main Characters",
                    type: "skin",
                    items: [
                        {
                            separator: true,
                            name: "Males"
                        },
                        { name: "Rico", id: "rico" },
                        { name: "Sargento", id: "sargento" },
                        { name: "Sheldon", id: "sheldon" },
                        { name: "Javi", id: "javi" },
                        { name: "Oscar", id: "oscar" },
                        { name: "Cesar", id: "cesar" },
                        { name: "Lanza", id: "lanza" },
                        {
                            separator: true,
                            name: "Females"
                        },
                        { name: "Mira", id: "mira" },
                        { name: "Garland", id: "garland" },
                        { name: "Izzy", id: "izzy" },
                    ]
                },
                {
                    name: "Black Hand",
                    type: "skin",
                    items: [
                        {
                            separator: true,
                            name: "Males"
                        },
                        { name: "Elite Enemy", id: "elite_enemy_001" },
                        { name: "Ghost Enemy", id: "ghost_enemy_001" },
                        { name: "Grenadier Enemy", id: "grenadier_enemy_001" },
                        { name: "Machinegunner Enemy", id: "machinegunner_enemy_001" },
                        { name: "Elite Paratrooper", id: "elite_paratrooper" },
                        { name: "Private Enemy", id: "private_enemy_001" },
                        {
                            name: "Rpg Enemy",
                            id: "rpg_enemy_001"
                        },
                        {
                            name: "Shielder Enemy",
                            id: "shielder_enemy_001"
                        },
                        {
                            name: "Sniper Enemy",
                            id: "sniper_enemy_001"
                        },
                        {
                            name: "Super Elite Enemy",
                            id: "super_elite_enemy_001"
                        },
                        {
                            name: "Titan Enemy",
                            id: "titan_enemy_001"
                        },
                        {
                            separator: true,
                            name: "Females"
                        },
                        { name: "Gabriela", id: "gabriela" },
                        {
                            name: "Private Enemy",
                            id: "private_enemy_002"
                        },
                    ]
                },
                {
                    name: "Combatants",
                    type: "skin",
                    items: [
                        {
                            separator: true,
                            name: "Males"
                        },
                        {
                            name: "Rebel Prisoner 1",
                            id: "male_rebel_prisoner_01"
                        },
                        {
                            name: "Rebel Prisoner 2",
                            id: "male_rebel_prisoner_02"
                        },
                        {
                            name: "Rebel Prisoner 3",
                            id: "male_rebel_prisoner_03"
                        },
                        {
                            name: "Rebel Tier 1 1",
                            id: "male_rebel_tier_1_01"
                        },
                        {
                            name: "Rebel Tier 1 2",
                            id: "male_rebel_tier_1_02"
                        },
                        {
                            name: "Rebel Tier 1 3",
                            id: "male_rebel_tier_1_03"
                        },
                        {
                            name: "Rebel Tier 1 4",
                            id: "male_rebel_tier_1_04"
                        },
                        {
                            name: "Rebel Tier 2 1",
                            id: "male_rebel_tier_2_01"
                        },
                        {
                            name: "Rebel Tier 2 2",
                            id: "male_rebel_tier_2_02"
                        },
                        {
                            name: "Rebel Tier 2 3",
                            id: "male_rebel_tier_2_03"
                        },
                        {
                            name: "Rebel Tier 2 4",
                            id: "male_rebel_tier_2_04"
                        },
                        {
                            name: "Rebel Tier 3 1",
                            id: "male_rebel_tier_3_01"
                        },
                        {
                            name: "Rebel Tier 3 2",
                            id: "male_rebel_tier_3_02"
                        },
                        {
                            name: "Rebel Tier 3 3",
                            id: "male_rebel_tier_3_03"
                        },
                        {
                            name: "Rebel Tier 3 4",
                            id: "male_rebel_tier_3_04"
                        },
                        {
                            name: "Sargentos Rebel 1",
                            id: "sargentos_rebel_male_01"
                        },
                        {
                            name: "Sargentos Rebel 2",
                            id: "sargentos_rebel_male_02"
                        },
                        {
                            name: "Sargentos Rebel 3",
                            id: "sargentos_rebel_male_03"
                        },
                        {
                            separator: true,
                            name: "Females"
                        },
                        {
                            name: "Rebel Prisoner 1",
                            id: "female_rebel_prisoner_01"
                        },
                        {
                            name: "Rebel Prisoner 2",
                            id: "female_rebel_prisoner_02"
                        },
                        {
                            name: "Rebel Prisoner 3",
                            id: "female_rebel_prisoner_03"
                        },
                        {
                            name: "Rebel Tier 1 1",
                            id: "female_rebel_tier_1_01"
                        },
                        {
                            name: "Rebel Tier 1 2",
                            id: "female_rebel_tier_1_02"
                        },
                        {
                            name: "Rebel Tier 1 3",
                            id: "female_rebel_tier_1_03"
                        },
                        {
                            name: "Rebel Tier 2 1",
                            id: "female_rebel_tier_2_01"
                        },
                        {
                            name: "Rebel Tier 2 2",
                            id: "female_rebel_tier_2_02"
                        },
                        {
                            name: "Rebel Tier 2 3",
                            id: "female_rebel_tier_2_03"
                        },
                        {
                            name: "Rebel Tier 3 1",
                            id: "female_rebel_tier_3_01"
                        },
                        {
                            name: "Rebel Tier 3 2",
                            id: "female_rebel_tier_3_02"
                        },
                        {
                            name: "Rebel Tier 3 3",
                            id: "female_rebel_tier_3_03"
                        },
                        {
                            name: "Rebel Female 1",
                            id: "sargentos_rebel_female_01"
                        },
                        {
                            name: "Rebel Female 2",
                            id: "sargentos_rebel_female_02"
                        },
                        {
                            name: "Rebel Female 3",
                            id: "sargentos_rebel_female_03"
                        },
                    ]
                },
                {
                    name: "Civilians",
                    type: "skin",
                    items: [
                        {
                            "separator": true,
                            "name": "Males"
                        },
                        {
                            "name": "Alpine Scientist",
                            "id": "civ_alpine_scientist_male"
                        },
                        {
                            "name": "Scientist",
                            "id": "civ_scientist_male"
                        },
                        {
                            "name": "Alpine Worker",
                            "id": "civ_alpine_worker_male_01"
                        },
                        {
                            "name": "Node Hacker 1",
                            "id": "civ_node_hacker_male_01"
                        },
                        {
                            "name": "Node Hacker 2",
                            "id": "civ_node_hacker_male_02"
                        },
                        {
                            "name": "Node Hacker 3",
                            "id": "civ_node_hacker_male_03"
                        },
                        {
                            "name": "Node Hacker 4",
                            "id": "civ_node_hacker_male_04"
                        },
                        {
                            "name": "Techengineer",
                            "id": "civ_techengineer_male"
                        },
                        {
                            "name": "Miner",
                            "id": "civ_miner_male"
                        },
                        {
                            "name": "Construction Worker",
                            "id": "civ_construction_worker_male_01"
                        },
                        {
                            "name": "Lumberyard",
                            "id": "civ_lumberyard_male_01"
                        },
                        {
                            "name": "Mechanic",
                            "id": "civ_mechanic_male_01"
                        },
                        {
                            "name": "Evil Target",
                            "id": "civ_evil_target_male_01"
                        },
                        {
                            "name": "Garland Crew",
                            "id": "civ_garland_crew_male_01"
                        },
                        {
                            "name": "Garland Location Scout",
                            "id": "civ_garland_location_scout_001"
                        },
                        {
                            "name": "Garland Pa",
                            "id": "civ_garland_pa_male_01"
                        },
                        {
                            "name": "Garland Stuntperson Helmet",
                            "id": "civ_garland_stuntperson_helmet_male_01"
                        },
                        {
                            "name": "Javi Soldier",
                            "id": "civ_javi_soldier_001"
                        },
                        {
                            "name": "Javi Soldier Full Body",
                            "id": "civ_javi_soldier_full_body"
                        },
                        {
                            "name": "Sargento Soldier",
                            "id": "civ_sargento_soldier_male_01"
                        },
                        {
                            "name": "Prisoner",
                            "id": "civ_prisoner_male"
                        },
                        {
                            "name": "Brrd",
                            "id": "civ_brrd_male_01"
                        },
                        {
                            "name": "Greenman",
                            "id": "civ_greenman_male_01"
                        },
                        {
                            "name": "Matsuda",
                            "id": "civ_matsuda_male_01"
                        },
                        {
                            "name": "Rome",
                            "id": "civ_rome_male_01"
                        },
                        {
                            "name": "Beachgoer",
                            "id": "civ_beachgoer_male_01"
                        },
                        {
                            "name": "Favela",
                            "id": "civ_favela_male_01"
                        },
                        {
                            "name": "Rainforest",
                            "id": "civ_rainforest_male_01"
                        },
                        {
                            "name": "Desert",
                            "id": "civ_desert_male_01"
                        },
                        {
                            "name": "Grasslands",
                            "id": "civ_grasslands_male_01"
                        },
                        {
                            "name": "Business",
                            "id": "civ_business_male_001"
                        },
                        {
                            "name": "Vagrant",
                            "id": "civ_vagrant_male_001"
                        },
                        {
                            "name": "Athletic",
                            "id": "civ_athletic_male_001"
                        },
                        {
                            "name": "Soccer Aa",
                            "id": "civ_soccer_aa_male_01"
                        },
                        {
                            "name": "Soccer Esp",
                            "id": "civ_soccer_esp_male_01"
                        },
                        {
                            "name": "Soccer",
                            "id": "civ_soccer_male_001"
                        },
                        {
                            "name": "Upperclass",
                            "id": "civ_upperclass_male_01"
                        },
                        {
                            "name": "Farmer",
                            "id": "civ_farmer_male_01"
                        },
                        {
                            "name": "Bartender",
                            "id": "civ_bartender_male_01"
                        },
                        {
                            "name": "Airport Worker",
                            "id": "civ_airport_worker_male_01"
                        },
                        {
                            "name": "Art Vendor",
                            "id": "civ_art_vendor_male_01"
                        },
                        {
                            "name": "Factory Worker",
                            "id": "civ_factory_worker_male_01"
                        },
                        {
                            "name": "Food Vendor",
                            "id": "civ_food_vendor_male_01"
                        },
                        {
                            "name": "Gas Station",
                            "id": "civ_gas_station_male_01"
                        },
                        {
                            "name": "Graffitiartist",
                            "id": "civ_graffitiartist_male_01"
                        },
                        {
                            "name": "Street Musician",
                            "id": "civ_street_musician_male_01"
                        },
                        {
                            "separator": true,
                            "name": "Females"
                        },
                        {
                            "name": "Alpine Scientist",
                            "id": "civ_alpine_scientist_female"
                        },
                        {
                            "name": "Scientist",
                            "id": "civ_scientist_female"
                        },
                        {
                            "name": "Alpine Worker",
                            "id": "civ_alpine_worker_female_01"
                        },
                        {
                            "name": "Techengineer",
                            "id": "civ_techengineer_female"
                        },
                        {
                            "name": "Construction Worker",
                            "id": "civ_construction_worker_female_01"
                        },
                        {
                            "name": "Lumberyard",
                            "id": "civ_lumberyard_female_01"
                        },
                        {
                            "name": "Mechanic",
                            "id": "civ_mechanic_female_01"
                        },
                        {
                            "name": "Steelworker",
                            "id": "civ_steelworker_female_01"
                        },
                        {
                            "name": "Evil Target",
                            "id": "civ_evil_target_female_01"
                        },
                        {
                            "name": "Garland Crew",
                            "id": "civ_garland_crew_female_01"
                        },
                        {
                            "name": "Garland Pa",
                            "id": "civ_garland_pa_001"
                        },
                        {
                            "name": "Garland Stuntperson Helmet",
                            "id": "civ_garland_stuntperson_helmet_female_01"
                        },
                        {
                            "name": "Sargento Soldier",
                            "id": "civ_sargento_soldier_female_01"
                        },
                        {
                            "name": "Prisoner",
                            "id": "civ_prisoner_female"
                        },
                        {
                            "name": "Bolo Santosi",
                            "id": "civ_bolo_santosi_01"
                        },
                        {
                            "name": "Greenman",
                            "id": "civ_greenman_female_01"
                        },
                        {
                            "name": "Beachgoer",
                            "id": "civ_beachgoer_female_01"
                        },
                        {
                            "name": "Favela",
                            "id": "civ_favela_female_01"
                        },
                        {
                            "name": "Rainforest",
                            "id": "civ_rainforest_female_01"
                        },
                        {
                            "name": "Desert",
                            "id": "civ_desert_female_01"
                        },
                        {
                            "name": "Grasslands",
                            "id": "civ_grasslands_female_01"
                        },
                        {
                            "name": "Business",
                            "id": "civ_business_female_001"
                        },
                        {
                            "name": "Vagrant",
                            "id": "civ_vagrant_female_001"
                        },
                        {
                            "name": "Athletic",
                            "id": "civ_athletic_female_001"
                        },
                        {
                            "name": "Soccer Aa",
                            "id": "civ_soccer_aa_female_01"
                        },
                        {
                            "name": "Soccer Esp",
                            "id": "civ_soccer_esp_female_01"
                        },
                        {
                            "name": "Soccer",
                            "id": "civ_soccer_female_001"
                        },
                        {
                            "name": "Upperclass",
                            "id": "civ_upperclass_female_01"
                        },
                        {
                            "name": "Farmer",
                            "id": "civ_farmer_female_01"
                        },
                        {
                            "name": "Bartender",
                            "id": "civ_bartender_female_01"
                        },
                        {
                            "name": "Airport Worker",
                            "id": "civ_airport_worker_female_01"
                        },
                        {
                            "name": "Art Vendor",
                            "id": "civ_art_vendor_female_01"
                        },
                        {
                            "name": "Factory Worker",
                            "id": "civ_factory_worker_female_01"
                        },
                        {
                            "name": "Food Vendor",
                            "id": "civ_food_vendor_female_01"
                        },
                        {
                            "name": "Gas Station",
                            "id": "civ_gas_station_female_01"
                        },
                        {
                            "name": "Graffitiartist",
                            "id": "civ_graffitiartist_female_01"
                        },
                        {
                            "name": "Street Musician",
                            "id": "civ_street_musician_female_01"
                        }
                    ]
                },
                {
                    name: "DLC",
                    type: "skin",
                    items: [
                        {
                            separator: true,
                            name: "Agency DLC"
                        },
                        {
                            name: "Agent Enemy Female 1",
                            id: "agency_agent_enemy_female_001"
                        },
                        {
                            name: "Agent Enemy Male 1",
                            id: "agency_agent_enemy_male_001"
                        },
                        {
                            name: "Agent Enemy VIP Female 1",
                            id: "agency_agent_enemy_vip_female01"
                        },
                        {
                            name: "Agent Enemy VIP Female 2",
                            id: "agency_agent_enemy_vip_female02"
                        },
                        {
                            name: "Agent Enemy VIP Female 3",
                            id: "agency_agent_enemy_vip_female03"
                        },
                        {
                            name: "Agent Enemy VIP Male 1",
                            id: "agency_agent_enemy_vip_male01"
                        },
                        {
                            name: "Agent Enemy VIP Male 2",
                            id: "agency_agent_enemy_vip_male02"
                        },
                        {
                            name: "Agent Enemy VIP Male 3",
                            id: "agency_agent_enemy_vip_male03"
                        },
                        {
                            name: "Agent Enemy VIP Titan 1",
                            id: "agency_agent_enemy_vip_titan01"
                        },
                        {
                            name: "Footsoldier Enemy Female 1",
                            id: "agency_footsoldier_enemy_female_001"
                        },
                        {
                            name: "Footsoldier Enemy Male 1",
                            id: "agency_footsoldier_enemy_male_001"
                        },
                        {
                            name: "Sniper Enemy Female 1",
                            id: "agency_sniper_enemy_female_001"
                        },
                        {
                            name: "Sniper Enemy Male 1",
                            id: "agency_sniper_enemy_male_001"
                        },
                        {
                            name: "Agent Miller",
                            id: "agent_miller"
                        },
                        {
                            name: "Sheldon (Agency)",
                            id: "sheldon_dlc3"
                        },
                        {
                            separator: true,
                            name: "Daredevil DLC"
                        },
                        {
                            name: "Ex-Convict Racer Female 1",
                            id: "civ_exconvict_racer_female_01"
                        },
                        {
                            name: "Ex-Convict Racer Female 2",
                            id: "civ_exconvict_racer_female_02"
                        },
                        {
                            name: "Ex-Convict Racer Female 3",
                            id: "civ_exconvict_racer_female_03"
                        },
                        {
                            name: "Ex-Convict Racer Male 1",
                            id: "civ_exconvict_racer_male_01"
                        },
                        {
                            name: "Ex-Convict Racer Male 2",
                            id: "civ_exconvict_racer_male_02"
                        },
                        {
                            name: "Ex-Convict Racer Male 3",
                            id: "civ_exconvict_racer_male_03"
                        },
                        {
                            name: "Mechanic Racer Female 1",
                            id: "civ_mechanic_racer_female_01"
                        },
                        {
                            name: "Mechanic Racer Female 2",
                            id: "civ_mechanic_racer_female_02"
                        },
                        {
                            name: "Mechanic Racer Female 3",
                            id: "civ_mechanic_racer_female_03"
                        },
                        {
                            name: "Mechanic Racer Male 1",
                            id: "civ_mechanic_racer_male_01"
                        },
                        {
                            name: "Mechanic Racer Male 2",
                            id: "civ_mechanic_racer_male_02"
                        },
                        {
                            name: "Mechanic Racer Male 3",
                            id: "civ_mechanic_racer_male_03"
                        },
                        {
                            name: "Trendy Racer Escarlata",
                            id: "civ_trendy_racer_escarlata"
                        },
                        {
                            name: "Trendy Racer Female 1",
                            id: "civ_trendy_racer_female_01"
                        },
                        {
                            name: "Trendy Racer Female 2",
                            id: "civ_trendy_racer_female_02"
                        },
                        {
                            name: "Trendy Racer Female 3",
                            id: "civ_trendy_racer_female_03"
                        },
                        {
                            name: "Trendy Racer Male 1",
                            id: "civ_trendy_racer_male_01"
                        },
                        {
                            name: "Trendy Racer Male 2",
                            id: "civ_trendy_racer_male_02"
                        },
                        {
                            name: "Trendy Racer Male 3",
                            id: "civ_trendy_racer_male_03"
                        },
                    ]
                }
            ]
        }
    ]
};