/*
Author: DarkWiiPlayer
Description: Spawns a supply box at a random position within an area
License: MIT
Parameters:
	- Center Position
	- Area Radius
	- Placement Radius
	- Altitude
*/

if (!isServer) exitWith {};

params ["_center", ["_area", 3000, [0, []], 3], ["_placement", 500, [0, []], 3], ["_altitude", [300, 400, 600], [0, []], 3]];
private [ "_para", "_crate", "_marker", "_cleanup", "_pos", "_event", "_logic" ];

if (typename _center == "OBJECT") then { _center = position _center };
if (typename _area == "ARRAY") then { _area = random _area };
if (typename _placement == "ARRAY") then { _placement = random _placement };
if (typename _altitude == "ARRAY") then { _altitude = random _altitude };

// _marker = createMarker [format ["crate_%1_%i", _center select 0, _center select 1], _center];
// _marker setMarkerShape "ELLIPSE";
// _marker setMarkerSize [_area, _area];

_crate = createVehicle ["C_T_supplyCrate_F", _center, [], _area - _placement];
[_crate] call DWP_fnc_boxFill;
_pos = position _crate;

_para = createVehicle ["B_Parachute_02_F", _pos, [], _placement];
_para setPosATL [(_pos select 0), (_pos select 1), ((_pos select 2)+_altitude)]; // Chute altitude
_crate attachTo [_para, [0, 0, 0]];

_marker = createMarker [format ["crate_%1_%i", _pos select 0, _pos select 1], _pos];
_marker setMarkerShape "ELLIPSE";
_marker setMarkerSize [_placement, _placement];

waitUntil { getPosATL _crate select 2 < 2 }; // Drop altitude
detach _crate;

_cleanup = {
	params ["_crate", "_marker"];

	deleteMarker _marker;
	waitUntil { (nearestObject [position _crate, "Man"]) distance _crate > 300 }; // Despawn distance
	deleteVehicle _crate;
};
_event = _crate addEventHandler ["containerOpened", _cleanup];

sleep (60 * 15); // Despawn time

_crate removeEventHandler ["containerOpened", _event];
[_crate, _marker] call _cleanup;

/*
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
