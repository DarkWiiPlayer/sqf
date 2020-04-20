params [
	["_target", objNull, [objNull]]
];

if (isNull _target) exitWith {};
if (local _target) then {
	_target disableAI "MOVE";
	_target disableAI "AUTOCOMBAT";
	_target disableAI "COVER";
};

private _condition = "(_this distance _target < 5) and (count currentWeapon _this > 0) and (!weaponLowered _this) and (alive _target) and !(_target getVariable ['robberyOngoing', false])";
[
	_target,
	localize "STR_dwp_robAction",
	"", // idle
	"", // progress
	_condition, // condition show
	_condition, // condition progress
	{}, // Start
	{}, // Progress
	{ [_target] remoteExec ["DWP_fnc_startRobbery", 2, false] }, // Complete
	{}, // Interrupted
	[], // Arguments
	3,
	9,
	false
] call BIS_fnc_holdActionAdd;
