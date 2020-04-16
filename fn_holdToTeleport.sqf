/*
	holdToTeleport
	Author: DarkWiiPlayer

	Arguments[]
		1: Teleport Object
		2: Teleport Target
		3: Menu Text
*/

if (!isServer) exitWith {}; //run only on server

private ['_object', '_target', '_menutext'];

_object = param [0, objNull, [objNull]];
_target = param [1, objNull, [objNull]];
_menutext = param [2, "Teleport", [""]];

if (isNull _object) then {
	["Teleport Object is NULL"] call BIS_fnc_error;
};

if (isNull _target) then {
	["Teleport Target is NULL"] call BIS_fnc_error;
};

[
	_object,
	if (_menutext select [0,1] == "@") then {localize (_menutext select [1])} else {_menutext},
	"",
	"",
	"_this distance _target <3",
	"_caller distance _target <5",
	{},
	{},
	{
		private ["_door", "_caller", "_target"];
		_door = _this select 0;
		_caller = _this select 1;
		_target = _this select 3 select 0;
		cutText ["", "BLACK OUT", 3, true];
		sleep 1;
		disableUserInput true;
		sleep 2;
		_caller setPosASL getPosASL _target;
		_caller setDir direction _target;
		sleep 3;
		disableUserInput false;
		cutText ["", "BLACK IN", 3, true];
	},
	{},
	[_target],
	3,
	0,
	false,
	false
] remoteExec ["BIS_fnc_holdActionAdd", 0, true];
