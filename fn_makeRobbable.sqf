/*
	Author: DarkWiiPlayer
	Description: Makes it so an NPC can be robbed (meant for altis life). Disables some AI types so NPC will stand still.
	Arguments:
	-	Target — Object to attach action to
	Dependencies:
	-	fn_startRobbery.sqf as DWP_fnc_startRobbery
	Bugs: Currently all "weapons" are being counted, including binoculars	
	License: Unlicense (Public Domain)
*/

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

/*
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
