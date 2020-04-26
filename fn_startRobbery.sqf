/*
	WIP warning! I still have plans for this script and might restructure it considerably
	
	Description: Starts robbing a given NPC
	Authors: DarkWiiPlayer
	Arguments:
	-	NPC being robbed
	Object Variables:
	-	money — How much money the robbery will yield (default 1000)
	-	robberyTime — How long the robbery will last in seconds (default 5 minutes)
	-	robberyCooldown — How long the robbery will be disabled after completion
	TODO:
	-	Hands up animation
	-	Mechanic to avoid alarm going of similar to payday; players have to continuously interact with NPC
	License: MIT
*/

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

/*
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
