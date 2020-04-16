/*
	distanceRespawn
	Author: DarkWiiPlayer
	
	Arguments[]
		1: Target object
		2: Distance
		3: Cooldown
		4: Curator: array
		5: onRespawn: code
*/

if (!isServer) exitWith {}; //run only on server

private ["_new", "_old", "_distance", "_timeout", "_curator", "_onRespawn", "_condition", "_pos", "_dir", "_class", "_customization", "_vars"];

_new = param [0];
_distance = param [1, 10];
_cooldown = param [2, 0];
_curator = param [3, [], []];
_onRespawn = param [4, {}, [{}]];

_startASL = getPosASL _new;
_prevASL = getPosASL _new;
_dir = direction _new;
_class = typeof _new;
_vars = [];
{ _vars pushBack [_x, _new getVariable _x] } forEach allVariables _new;

sleep 2;
_customization = [_new] call BIS_fnc_getVehicleCustomization;

clearItemCargoGlobal _new;
clearMagazineCargoGlobal _new;
clearWeaponCargoGlobal _new;
clearBackpackCargoGlobal _new;

while {true} do {
	waitUntil {((getPosASL _new distance _prevASL) > _distance) or (not alive _new)};

	_old = _new;

	// Add to curator
	if (_curator isEqualType []) then {
		{_x addCuratorEditableObjects [[_old], false];} forEach _curator;
	} else {
		if (not isNull _curator) then {
			_curator addCuratorEditableObjects [[_old], false];
		}
	};
	
	// Spawn new vehicle
	
	_new = _class createVehicle _startASL;
	[_new, _customization select 0 select 0, _customization select 1] call BIS_fnc_initVehicle;
	_prevASL = getPosASL _new;

	// Set variables on new vehicle
	{ _new setVariable [(_x select 0), (_x select 1)]} forEach _vars;

	// Add AI if the unit is a UAV UGV
	if (unitIsUAV _new) then {
		createVehicleCrew _new;
	};

	// Initialize new unit
	_new setDir _dir;
	clearItemCargoGlobal _new;
	clearMagazineCargoGlobal _new;
	clearWeaponCargoGlobal _new;
	clearBackpackCargoGlobal _new;
	
	// Respawn callback
	[_new, _old] call _onRespawn;
	
	// Delete old if dead
	if (not alive _old) then {
		deleteVehicle _old;
	};

	sleep _cooldown;
};
