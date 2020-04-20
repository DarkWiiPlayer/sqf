params [
	["_target", objNull, [objNull]]
];

private _money = _target getVariable ["money", 1000];
private _robberyTime = _target getVariable ["robberyTime", 5 * 60];
private _robberyCooldown = _target getVariable ["robberyCooldown", 60];
private _tick = 10;

scopeName "main";

private _spawn = if (count synchronizedObjects _target > 0)
	then { synchronizedObjects _target select 0 }
	else { _target };

private _pos = position _target;
private _marker = createMarker [format ["robbery_%1_%i", _pos select 0, _pos select 1], _pos];
_marker setMarkerType "mil_warning";
_marker setMarkerColor "ColorRed";
_marker setMarkerText format ["Robo a %1", name _target];
_target setVariable ["robberyOngoing", true, true];

format ["Estan robando a %1!", name _target] remoteExec ["hint", "BLUFOR", false];

for "_second" from 1 to _robberyTime / _tick do {
	private _progress = _second / _robberyTime;

	if (!alive _target) then {
		deleteMarker _marker;
		breakOut "main";
	};

	sleep _tick;
};
private _reward = createVehicle ["Land_Money_F", getPosASL _spawn, [], 0, "CAN_COLLIDE"];
_reward setVariable ["item", ["money", _money], true];
_reward enableSimulation false;
_reward setPosASL getPosASL _spawn;

deleteMarker _marker;

sleep _robberyCooldown;
_target setVariable ["robberyOngoing", false, true];
