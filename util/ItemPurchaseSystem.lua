---------------------------------------------
-- Generated from Mirana Compiler version 1.6.2
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local BotsInit = require("game/botsinit")
local M = BotsInit.CreateGeneric()
local utility = require(GetScriptDirectory() .. "/utility")
local AbilityExtensions = require(GetScriptDirectory() .. "/util/AbilityAbstraction")
local TeamItemThink = require(GetScriptDirectory() .. "/util/TeamItemThink")
local A = require(GetScriptDirectory() .. "/util/MiraDota")
function M.SellExtraItem(ItemsToBuy)
    local npcBot = GetBot()
    local level = npcBot:GetLevel()
    if M.IsItemSlotsFull() then
        if GameTime() > 25 * 60 or level >= 10 then
            M.SellSpecifiedItem("item_orb_of_venom")
            M.SellSpecifiedItem("item_enchanted_mango")
        end
        if GameTime() > 35 * 60 or level >= 15 then
            M.SellSpecifiedItem("item_branches")
            M.SellSpecifiedItem("item_bottle")
            M.SellSpecifiedItem("item_magic_wand")
            M.SellSpecifiedItem("item_flask")
            M.SellSpecifiedItem("item_ancient_janggo")
            M.SellSpecifiedItem("item_ring_of_basilius")
            M.SellSpecifiedItem("item_quelling_blade")
            M.SellSpecifiedItem("item_soul_ring")
            M.SellSpecifiedItem("item_buckler")
            M.SellSpecifiedItem("item_headdress")
            M.SellSpecifiedItem("item_bracer")
            M.SellSpecifiedItem("item_null_talisman")
            M.SellSpecifiedItem("item_wraith_band")
        end
        if GameTime() > 40 * 60 or level >= 20 then
            M.SellSpecifiedItem("item_urn_of_shadows")
            M.SellSpecifiedItem("item_drums_of_endurance")
            M.SellSpecifiedItem("item_witch_blade")
        end
    end
end

local function isLeaf(Node)
    return next(GetItemComponents(Node)) == nil
end

local function nextNodes(Node)
    return GetItemComponents(Node)[1]
end

M.ExpandItemRecipe = function(self, itemTable)
    local output = {}
    local expandItem
    expandItem = function(item)
        if isLeaf(item) then
            table.insert(output, item)
        else
            for _, v in pairs(nextNodes(item)) do
                expandItem(item)
            end
        end
    end
    for _, v in pairs(itemTable) do
        expandItem(v)
    end
    return output
end
function M.NoNeedTpscrollForTravelBoots()
    local npcBot = GetBot()
    local item_travel_boots = {}
    local item_travel_boots_1 = nil
    local item_travel_boots_2 = nil
    for i = 0, 14 do
        local sCurItem = npcBot:GetItemInSlot(i)
        if sCurItem ~= nil and sCurItem:GetName() == "item_travel_boots_1" then
            item_travel_boots_1 = sCurItem
        end
        if sCurItem ~= nil and sCurItem:GetName() == "item_travel_boots_2" then
            item_travel_boots_2 = sCurItem
        end
    end
    if item_travel_boots_1 ~= nil or item_travel_boots_2 ~= nil then
        for i = 0, 14 do
            local sCurItem = npcBot:GetItemInSlot(i)
            if sCurItem ~= nil and sCurItem:GetName() == "item_tpscroll" then
                npcBot:ActionImmediate_SellItem("item_tpscroll")
            end
        end
    end
    item_travel_boots[1] = item_travel_boots_1
    item_travel_boots[2] = item_travel_boots_2
    return item_travel_boots
end

function M.WeNeedTpscroll()
    local npcBot = GetBot()
    local item_travel_boots = M.NoNeedTpscrollForTravelBoots()
    local item_travel_boots_1 = item_travel_boots[1]
    local item_travel_boots_2 = item_travel_boots[2]
    local iScrollCount = 0
    for i = 9, 16 do
        local sCurItem = npcBot:GetItemInSlot(i)
        if sCurItem ~= nil and sCurItem:GetName() == "item_tpscroll" then
            iScrollCount = iScrollCount + sCurItem:GetCurrentCharges()
        end
    end
    if DotaTime() <= 3 * 60 then
        return
    end
    if ((iScrollCount <= 2 and DotaTime() >= 5 * 60) or iScrollCount == 0) and item_travel_boots_1 == nil and
        item_travel_boots_2 == nil then
        if npcBot:DistanceFromFountain() <= 200 then
            if DotaTime() > 2 * 60 and DotaTime() < 20 * 60 then
                npcBot:ActionImmediate_PurchaseItem("item_tpscroll")
            elseif DotaTime() >= 20 * 60 then
                npcBot:ActionImmediate_PurchaseItem("item_tpscroll")
            end
        else
            npcBot:ActionImmediate_PurchaseItem("item_tpscroll")
        end
    end
end

function M.SellSpecifiedItem(item_name)
    local npcBot = GetBot()
    local itemCount = 0
    local item = nil
    for i = 0, 14 do
        local sCurItem = npcBot:GetItemInSlot(i)
        if sCurItem ~= nil then
            itemCount = itemCount + 1
            if sCurItem:GetName() == item_name then
                item = sCurItem
            end
        end
    end
    if item ~= nil and itemCount > 5 and
        (
        npcBot:DistanceFromFountain() <= 600 or npcBot:DistanceFromSideShop() <= 200 or
            npcBot:DistanceFromSecretShop() <= 200) then
        npcBot:ActionImmediate_SellItem(item)
    end
end

function M.GetItemSlotsCount2(npcBot)
    local itemCount = 0
    for i = 0, 8 do
        local sCurItem = npcBot:GetItemInSlot(i)
        if sCurItem ~= nil then
            itemCount = itemCount + 1
        end
    end
    return itemCount
end

function M.GetItemSlotsCount()
    local npcBot = GetBot()
    local itemCount = 0
    for i = 0, 8 do
        local sCurItem = npcBot:GetItemInSlot(i)
        if sCurItem ~= nil then
            itemCount = itemCount + 1
        end
    end
    return itemCount
end

function M.IsItemSlotsFull()
    return M.GetItemSlotsCount() >= 8
end

function M.checkItemBuild(ItemsToBuy)
    local ItemTableA = {
        "item_tango",
        "item_clarity",
        "item_faerie_fire",
        "item_enchanted_mango",
        "item_flask",
    }
    if DotaTime() > 0 then
        for _, item in pairs(ItemTableA) do
            for _1, item2 in pairs(ItemsToBuy) do
                if item == item2 then
                    table.remove(ItemsToBuy, _1)
                end
            end
        end
        local npcBot = GetBot()
        for _1, item2 in pairs(ItemsToBuy) do
            if npcBot:FindItemSlot(item2) > 0 then
                table.remove(ItemsToBuy, _1)
            end
        end
    end
end

function M.GetItemIncludeBackpack(item_name)
    local npcBot = GetBot()
    for i = 0, 16 do
        local item = npcBot:GetItemInSlot(i)
        if item ~= nil then
            if item:GetName() == item_name then
                return item
            end
        end
    end
    return nil
end

function M.IsItemAvailable(item_name)
    local npcBot = GetBot()
    for i = 0, 5, 1 do
        local item = npcBot:GetItemInSlot(i)
        if item ~= nil then
            if item:GetName() == item_name then
                return item
            end
        end
    end
    return nil
end

function M.GetOtherTeam()
    if GetTeam() == TEAM_RADIANT then
        return TEAM_DIRE
    else
        return TEAM_RADIANT
    end
end

function M.CheckInvisibleEnemy()
    return TeamItemThink.CheckInvisibleEnemy()
end

local hasInvisibleEnemy = false
local BuySupportItem_Timer = DotaTime()
function M.BuySupportItem()
    local npcBot = GetBot()
    if DotaTime() - BuySupportItem_Timer >= 10 then
        BuySupportItem_Timer = DotaTime()
        hasInvisibleEnemy = M.CheckInvisibleEnemy()
    end
    if M.GetItemSlotsCount() < 7 then
        local item_ward_dispenser = M.GetItemIncludeBackpack("item_ward_dispenser")
        if item_ward_dispenser then
            local wardState = item_ward_dispenser:GetToggleState()
            local observerCount = item_ward_dispenser:GetCurrentCharges()
            local sentryCount = item_ward_dispenser:GetSecondaryCharges()
        end
        local item_ward_observer = M.GetItemIncludeBackpack("item_ward_observer")
        local item_ward_sentry = M.GetItemIncludeBackpack("item_ward_dispenser")
        local item_gem = M.GetItemIncludeBackpack("item_gem")
        local item_smoke = M.GetItemIncludeBackpack("item_smoke_of_deceit")
        if DotaTime() >= 0 and hasInvisibleEnemy then
            local item_dust = M.GetItemIncludeBackpack("item_dust")
            if item_gem == nil and M.HaveGem() == false then
                if item_dust == nil and item_ward_sentry == nil and npcBot:GetGold() >= 2 * GetItemCost("item_dust") and
                    GetItemStockCount("item_gem") >= 1 then
                    npcBot:ActionImmediate_PurchaseItem("item_dust")
                end
                if (
                    DotaTime() >= 25 * 60 and npcBot:GetGold() >= GetItemCost("item_gem") and
                        GetItemStockCount("item_gem") >= 1) and AbilityExtensions:GetEmptyItemSlots(npcBot) >= 1 then
                    if AbilityExtensions:GetEmptyItemSlots(npcBot) >= 1 and
                        AbilityExtensions:GetEmptyBackpackSlots(npcBot) == 0 then
                        npcBot:ActionImmediate_PurchaseItem("item_gem")
                    elseif AbilityExtensions:GetEmptyBackpackSlots(npcBot) >= 1 then
                        if AbilityExtensions:SwapCheapestItemToBackpack(npcBot) then
                            npcBot:ActionImmediate_PurchaseItem("item_gem")
                        end
                    else
                    end
                end
            end
        end
        if DotaTime() >= 30 * 60 and npcBot:GetGold() >= GetItemCost("item_gem") and GetItemStockCount("item_gem") >= 1
            and item_gem == nil and M.HaveGem() == false then
            npcBot:ActionImmediate_PurchaseItem("item_gem")
        end
        if item_ward_observer == nil and item_ward_sentry == nil and
            (GetItemStockCount("item_ward_observer") > 1 or DotaTime() < 0) and
            npcBot:GetGold() >= GetItemCost("item_ward_observer") then
            npcBot:ActionImmediate_PurchaseItem("item_ward_observer")
        end
        if item_smoke == nil and GetItemStockCount("item_smoke_of_deceit") >= 1 and
            npcBot:GetGold() >= GetItemCost("item_smoke_of_deceit") then
        end
    end
end

function M.HaveGem()
    for _, hero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
        local gem = hero:FindItemSlot("item_gem")
        if gem > 0 then
            return true
        end
    end
    return false
end

local key = ""
function M.PrintTable(table, level)
    level = level or 1
    local indent = ""
    for i = 1, level do
        indent = indent .. "  "
    end
    if key ~= "" then
        print(indent .. key .. " " .. "=" .. " " .. "{")
    else
        print(indent .. "{")
    end
    key = ""
    for k, v in pairs(table) do
        if type(v) == "table" then
            key = k
            M.PrintTable(v, level + 1)
        else
            local content = string.format("%s%s = %s", indent .. "  ", tostring(k), tostring(v))
            print(content)
        end
    end
    print(indent .. "}")
end

M.ItemName = {}
setmetatable(M.ItemName, { __index = function(tb, f)
    return "item_" .. f
end })
M.Consumables = {
    "clarity",
    "enchanted_mango",
    "faerie_fire",
    "tome_of_knowledge",
    "tango",
    "flask",
    "bottle",
    "tpscroll",
}
M.IsConsumableItem = function(self, item)
    return AbilityExtensions:Contains(self.Consumables, string.sub(item, 6))
end
local function ExpandFirstLevel(item)
    if isLeaf(item) then
        return {
            name = item,
            isSingleItem = true,
        }
    else
        return {
            name = item,
            recipe = nextNodes(item),
        }
    end
end

local function ExpandOnce(item)
    local g = {}
    local expandSomething = false
    for _, v in ipairs(item.recipe) do
        if isLeaf(v) then
            table.insert(g, v)
        else
            expandSomething = true
            for _, i in ipairs(nextNodes(v)) do
                table.insert(g, i)
            end
        end
    end
    item.recipe = g
    return expandSomething
end

local function PrintItemInfoTableOf(npcBot)
    local tb = npcBot.itemInformationTable
    print(npcBot:GetUnitName() .. " items to buy: ")
    A.Linq.ForEach(tb, function(t, index)
        if t.isSingleItem then
            print(index .. ": " .. t.name)
        else
            local s = ""
            A.Linq.ForEach(t.recipe, function(t1, t1Index)
                s = s .. t1
                if t1Index ~= #t.recipe then
                    s = s .. ", "
                end
            end)
            print(index .. ": " .. t.name .. " { " .. s .. " }")
        end
    end)
end

M.CreateItemInformationTable = function(self, npcBot, itemTable, noRemove)
    local g = A.Linq.NewTable()
    g.hero = npcBot
    if not A.Unit.CanBuyItem(npcBot) then
        npcBot.itemInformationTable = g
        return
    end
    local boughtItems = AbilityExtensions:GetAllBoughtItems(npcBot):Map(function(t)
        return {
            name = t:GetName(),
            charge = t:GetCurrentCharges(),
        }
    end)
    for _, item in pairs(itemTable) do
        local dontExpand
        if DotaTime() > 0 and M:IsConsumableItem(item) then
            dontExpand = true
        end
        for i, b in ipairs(boughtItems) do
            if item == b.name then
                dontExpand = true
                table.remove(boughtItems, i)
                break
            end
        end
        if item == "item_ultimate_scepter" and A.Hero.HasBoughtScepter(npcBot) then
            dontExpand = true
        end
        if item == "item_ultimate_scepter_2" and
            (
            npcBot:HasModifier "modifier_item_ultimate_scepter" or
                npcBot:HasModifier "modifier_item_ultimate_scepter_consumed_alchemist") then
            dontExpand = true
        end
        if item == "item_moon_shard" and npcBot:HasModifier "modifier_item_moon_shard_consumed" then
            dontExpand = true
        end
        if item == "item_aghanims_shard" and npcBot:HasModifier "modifier_item_agahanims_shard" then
            dontExpand = true
        end
        if not dontExpand then
            local itemInformation = ExpandFirstLevel(item)
            if itemInformation.isSingleItem then
            else
                ::expandSuccess::
                local recipe = itemInformation.recipe
                for _, builtItem in ipairs(g) do
                    if not builtItem.usedAsRecipeOf then
                        for componentIndex, componentName in ipairs(recipe) do
                            if componentName == builtItem.name then
                                builtItem.usedAsRecipeOf = itemInformation.name
                                table.remove(recipe, componentIndex)
                                break
                            end
                        end
                    end
                end
                ::removeBoughtItems::
                local boughtItemIndex = 1
                while boughtItemIndex <= #boughtItems do
                    local boughtItem = boughtItems[boughtItemIndex]
                    for componentIndex, componentName in ipairs(recipe) do
                        if componentName == boughtItem.name then
                            table.remove(boughtItems, boughtItemIndex)
                            table.remove(recipe, componentIndex)
                            goto removeBoughtItems
                        end
                    end
                    boughtItemIndex = boughtItemIndex + 1
                end
                if ExpandOnce(itemInformation) then
                    goto expandSuccess
                end
            end
            if itemInformation.recipe and #itemInformation.recipe > 0 or itemInformation.isSingleItem then
                table.insert(g, itemInformation)
            end
        end
    end
    npcBot.itemInformationTable = g
    local function RemoveTeamItems(t)
        local implmentedItems = TeamItemThink.ImplmentedTeamItems or {}
        AbilityExtensions:ForEach(implmentedItems, function(itemName)
            AbilityExtensions:Remove_Modify(t, function(itemInfo)
                return itemInfo.name == itemName
            end)
        end)
        return t
    end

    if not noRemove then
        RemoveTeamItems(g)
        TeamItemThink.TeamItemThink(npcBot)
    end
end
local sNextItem
local UseCourier = function()
    local npcBot = GetBot()
    if not A.Unit.CanBuyItem(npcBot) then
        return
    end
    local courier = AbilityExtensions:GetMyCourier(npcBot)
    if courier == nil then
        return
    end
    local courierState = GetCourierState(courier)
    if courierState == COURIER_STATE_DEAD then
        return
    end
    local courierItemNumber = #AbilityExtensions:GetCourierItems(courier)
    if not npcBot:IsAlive() then
        if courierState ~= COURIER_STATE_RETURNING_TO_BASE and courierState ~= COURIER_STATE_AT_BASE then
            npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_RETURN)
        end
        return
    end
    local nearSecretShop = courier:DistanceFromSecretShop() <= 180
    local function IsWaitingAtSecretShop()
        return courierState == COURIER_STATE_IDLE and nearSecretShop and npcBot:GetGold() >= GetItemCost(sNextItem) * 0.9
    end

    if courier.returnWhenCarryingTooMany then
        if courier:DistanceFromFountain() <= 1200 and courierState == COURIER_STATE_AT_BASE and
            (courier.returnCarryNumber < courierItemNumber or #AbilityExtensions:GetStashItems(npcBot) > 0) then
            npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS)
            courier.returnWhenCarryingTooMany = nil
            return
        end
        if courierState == COURIER_STATE_AT_BASE and IsItemPurchasedFromSecretShop(sNextItem) and
            npcBot:GetGold() >= GetItemCost(sNextItem) * 0.9 then
            npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_SECRET_SHOP)
            return
        end
        npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_RETURN)
        return
    end
    if AbilityExtensions:GetEmptyItemSlots(npcBot) == 0 and courierItemNumber > 0 and
        GetUnitToUnitDistance(npcBot, courier) <= 400 then
        courier.returnCarryNumber = courierItemNumber
        npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_RETURN)
        return
    end
    if #AbilityExtensions:GetStashItems(npcBot) ~= 0 then
        if (courierState == COURIER_STATE_AT_BASE or courierState == COURIER_STATE_IDLE) and not IsWaitingAtSecretShop() then
            npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS)
            return
        end
    end
    if #AbilityExtensions:GetCourierItems(courier) ~= 0 then
        if courierState ~= COURIER_STATE_DELIVERING_ITEMS and not IsWaitingAtSecretShop() then
            npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_TRANSFER_ITEMS)
            return
        end
    end
    if IsItemPurchasedFromSecretShop(sNextItem) and npcBot:GetGold() >= GetItemCost(sNextItem) * 0.9 then
        courier.returnWhenCarryingTooMany = nil
        if courierState == COURIER_STATE_AT_BASE then
            npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_SECRET_SHOP)
            return
        end
        if nearSecretShop and npcBot:GetGold() >= GetItemCost(sNextItem) then
            npcBot:ActionImmediate_PurchaseItem(sNextItem)
            return
        end
    end
end
UseCourier = AbilityExtensions:EveryManySeconds(0.5, UseCourier)
M.ItemPurchaseExtend = function(self, ItemsToBuy)
    local function GetTopItemToBuy()
        local itemInformationTable = GetBot().itemInformationTable
        if #itemInformationTable == 0 then
            return nil
        elseif itemInformationTable[1].isSingleItem then
            return itemInformationTable[1].name
        else
            return itemInformationTable[1].recipe[1]
        end
    end

    local function RemoveTopItemToBuy()
        local itemInformationTable = GetBot().itemInformationTable
        if itemInformationTable[1].isSingleItem then
            table.remove(itemInformationTable, 1)
        else
            table.remove(itemInformationTable[1].recipe, 1)
            if #itemInformationTable[1].recipe == 0 then
                table.remove(itemInformationTable, 1)
            end
        end
    end

    if GetGameState() == DOTA_GAMERULES_STATE_POSTGAME then
        return
    end
    local npcBot = GetBot()
    local function RemoveInvisibleItemsWhenBountyHunter()
        local enemies = AbilityExtensions:Filter(GetBot():GetNearbyHeroes(1500, true, BOT_MODE_NONE), function(t)
            return AbilityExtensions:MayNotBeIllusion(GetBot(), t)
        end)
        if AbilityExtensions:Any(enemies, function(t)
            return t:GetUnitName() == AbilityExtensions:GetHeroFullName("bounty_hunter") or
                t:GetUnitName() == AbilityExtensions:GetHeroFullName("slardar") or
                t:GetUnitName() == AbilityExtensions:GetHeroFullName("rattletrap") and t:GetLevel() >= 12
        end) then
            M:RemoveInvisibleItemPurchase(GetBot())
        end
    end

    if npcBot:IsIllusion() then
        return
    end
    if npcBot.secretShopMode ~= true or npcBot:GetGold() >= 100 then
        M.WeNeedTpscroll()
    end
    if #GetBot().itemInformationTable == 0 then
        npcBot:SetNextItemPurchaseValue(0)
        return
    end
    sNextItem = GetTopItemToBuy()
    npcBot:SetNextItemPurchaseValue(GetItemCost(sNextItem))
    M.SellExtraItem(ItemsToBuy)
    if npcBot:DistanceFromFountain() <= 2500 or npcBot:GetHealth() / npcBot:GetMaxHealth() <= 0.35 then
        npcBot.secretShopMode = false
    end
    if IsItemPurchasedFromSecretShop(sNextItem) == false then
        npcBot.secretShopMode = false
    end
    if npcBot:GetGold() >= GetItemCost(sNextItem) then
        if sNextItem == "item_aghanims_shard" and GetItemStockCount(sNextItem) < 1 then
            return
        end
        if npcBot.secretShopMode ~= true then
            if IsItemPurchasedFromSecretShop(sNextItem) and sNextItem ~= "item_bottle" then
                npcBot.secretShopMode = true
            end
        end
        local PurchaseResult = -2
        if npcBot.secretShopMode then
            if npcBot:DistanceFromSecretShop() <= 250 then
                PurchaseResult = npcBot:ActionImmediate_PurchaseItem(sNextItem)
            end
            local courier = AbilityExtensions:GetMyCourier(npcBot)
            local ItemCount = M.GetItemSlotsCount2(courier)
            if courier:DistanceFromSecretShop() <= 250 and ItemCount < 9 then
                PurchaseResult = courier:ActionImmediate_PurchaseItem(sNextItem)
            end
        else
            PurchaseResult = npcBot:ActionImmediate_PurchaseItem(sNextItem)
        end
        if PurchaseResult == PURCHASE_ITEM_SUCCESS then
            npcBot.secretShopMode = false
            RemoveTopItemToBuy()
        elseif PurchaseResult ~= -2 then
            print(npcBot:GetUnitName() ..
                "purchase item failed: " ..
                sNextItem .. ", fail code: " .. AbilityExtensions:ToIntItemPurchaseResult(PurchaseResult))
        end
        if PurchaseResult == PURCHASE_ITEM_OUT_OF_STOCK then
            M.SellSpecifiedItem("item_faerie_fire")
            M.SellSpecifiedItem("item_tango")
            M.SellSpecifiedItem("item_clarity")
            M.SellSpecifiedItem("item_flask")
        elseif PurchaseResult == PURCHASE_ITEM_INVALID_ITEM_NAME or PurchaseResult == PURCHASE_ITEM_DISALLOWED_ITEM then
            print("invalid item purchase or disallowed purchase: " .. sNextItem)
            RemoveTopItemToBuy()
        elseif PurchaseResult == PURCHASE_ITEM_INSUFFICIENT_GOLD then
            npcBot.secretShopMode = false
        elseif PurchaseResult == PURCHASE_ITEM_NOT_AT_SECRET_SHOP then
            npcBot.secretShopMode = true
        elseif PurchaseResult == PURCHASE_ITEM_NOT_AT_HOME_SHOP then
            npcBot.secretShopMode = false
        end
    else
        npcBot.secretShopMode = false
    end
    UseCourier()
end
M.RemoveItemPurchase = function(self, itemTable, itemName)
    local num = #itemTable
    local i = 1
    while i <= num do
        if itemTable[i].name == itemName then
            table.remove(itemTable, i)
            num = num - 1
        end
    end
end
M.InvisibleItemList = {
    "item_invis_sword",
    "item_silver_edge",
    "item_glimmer_cape",
}
M.RemoveInvisibleItemPurchase = function(self, itemTable)
    AbilityExtensions:ForEach(self.InvisibleItemList, function(t)
        self:RemoveItemPurchase(itemTable, t)
    end)
end
return M
