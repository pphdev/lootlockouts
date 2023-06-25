-- Namespace
local addonName, core = ...;
core.InstanceData = {};

local InstanceData = core.InstanceData;

InstanceData.dht = {"Archdruid Glaidalis", "Oakheart", "Dresaron", "Shade of Xavius"};
InstanceData.eoa = {"Warlord Parjesh", "Lady Hatecoil", "King Deepbeard", "Serpentrix", "Wrath of Azshara"}
InstanceData.cos = {"Patrol Captain Gerdo", "Talixae Flamewreath", "Advisor Melandrus"};
InstanceData.brh = {"Amalgam of Souls", "Illysanna Ravencrest", "Smashspite the Hateful", "Dantalionax"};
InstanceData.votw = {"Tirathon Saltheril", "Inquisitor Tormentorum", "Ash'Golm", "Glazer", "Cordana Felsong"};
InstanceData.mos = {"Ymiron, the Fallen King", "Harbaron", "Helya"};
InstanceData.arc = {"Ivanyr", "Corstilax", "General Xakal", "Nal'tira", "Advisor Vandros"};
InstanceData.nhl = {"Rokmora", "Ularogg Cragshaper", "Naraxas", "Dargrul"};
InstanceData.hov = {"Hymdall", "Hyrja", "Fenryr", "Skovald", "Odyn"};
InstanceData.vio = {"Festerface", "Shivermaw", "Blood-Princess Thal'ena", "Mindflayer Kaahrj", "\n", "Millificent Manastorm", "Anub'esset", "Sael'orn", "Fel Lord Betrug"}

InstanceData.en = {"Nythendra", "Elerethe Renferal", "Ursoc", "Il'gynoth", "Dragons of Nightmare", "Cenarius", "Xavius"};

InstanceData.instances = {NHL = InstanceData.nhl, DHT = InstanceData.dht, COS = InstanceData.cos, BRH = InstanceData.brh,
                      VOTW = InstanceData.votw, MOS = InstanceData.mos, ARC = InstanceData.arc, HOV = InstanceData.hov, VIO = InstanceData.vio,
                    EOA = InstanceData.eoa};

InstanceData.raids = {["EN (N)"] = InstanceData.en, ["EN (HC)"] = InstanceData.en, ["EN (M)"] = InstanceData.en};
InstanceData.raidkeys = {"EN (N)", "EN (HC)", "EN (M)"};