// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

Zen_Fire_Support_Round_Local = objNull;
Zen_Fire_Support_Target_Pos_Local = [];
Zen_Fire_Support_Array_Global = [];
Zen_Fire_Support_Comm_ID_Array_Local = [];

Zen_AddFireSupportAction = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_AddFireSupportAction.sqf";
Zen_CreateFireSupport = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_CreateFireSupport.sqf";
Zen_GetFireSupportData = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_GetFireSupportData.sqf";
Zen_GuideRound = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_GuideRound.sqf";
Zen_InvokeFireSupport = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_InvokeFireSupport.sqf";
Zen_InvokeFireSupportAction = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_InvokeFireSupportAction.sqf";
Zen_RemoveFireSupport = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_RemoveFireSupport.sqf";
Zen_RemoveFireSupportAction = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_RemoveFireSupportAction.sqf";
Zen_UpdateFireSupport = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_UpdateFireSupport.sqf";
Zen_UpdateFireSupportAction = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_UpdateFireSupportAction.sqf";

Zen_AddFireSupportAction_AddAction_MP = {
    if (!(isDedicated) && {hasInterface}) then {
        _IDs = [];
        {
            _actionID = _x addAction ["<t color='#990000'>" + (_this select 1) + "</t>", {(_this select 3) spawn Zen_InvokeFireSupportAction}, [(_this select 2), (_this select 3), (_this select 4)], 1, false, true, "", "(_target == _this)"];
            _IDs pushBack _actionID;
        } forEach (_this select 0);
        Zen_Fire_Support_Comm_ID_Array_Local pushBack [(_this select 2), (_this select 0), _IDs, 0, (_this select 5), (_this select 1), (_this select 3), (_this select 4)];
    };
};

Zen_InvokeFireSupportAction_UpdateData_MP = {
    if (!(isDedicated) && {hasInterface}) then {
        _indexes = [Zen_Fire_Support_Comm_ID_Array_Local, (_this select 0), 0] call Zen_ArrayGetNestedIndex;
        if (count _indexes > 0) then {
            _commArray = Zen_Fire_Support_Comm_ID_Array_Local select (_indexes select 0);
            _commArray set [3, ((_commArray select 3) + 1)];

            if ((_commArray select 3) >= (_commArray select 4) && {((_commArray select 4) != -1)}) then {
                0 = [(_commArray select 0), false] call Zen_RemoveFireSupportAction;
            };
        };
    };
};

Zen_InvokeFireSupportAction_SideChat_MP = {
    if (isDedicated || !hasInterface) exitWith {};
    private ["_unit", "_side", "_group", "_pos", "_sentTime"];

    _unit = _this select 0;
    _pos = _this select 1;
    _sentTime = _this select 2;

    _side = side _unit;

    if (side player != _side) exitWith {};

    _group = toArray str group _unit;
    _group = toString ([_group, 2] call Zen_ArrayGetIndexedSlice);

    _unit sideChat format ["HQ, %1, Request fire support at grid %2, over.", _group, (mapGridPosition _pos)];
    sleep 7;
    [_side, "base"] sideChat format ["%1, HQ, Fire support inbound in %2 seconds, out.", _group, _sentTime];
    if (true) exitWith {};
};

if (true) exitWith {};
