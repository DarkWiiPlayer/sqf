/*
Author: DarkWiiPlayer
Description: Fills a box with some random loot
License: MIT
Parameters:
	- Box
	- Config entry
*/

params [["_box", objNull, [objNull]], ["_name", "SupplyDrop", [""]]];
private [ "_config" ];

if (isNull _box) exitWith {};

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;
clearItemCargoGlobal _box;
clearBackpackCargoGlobal _box;

private ["_config"];
_config = missionConfigFile >> 'CfgRandomLoot' >> _name;

private ["_summ", "_array"];
_array = [ [0] ]; _summ = 0;

"true" configClasses _config apply {
	private ["_weight"];
	_weight = if (isNumber (_x >> "weight"))
		then { getNumber (_x >> "weight") }
		else { 1 };
	_summ = _summ + _weight;
	_array pushBack [ _summ, _x ];
};

private ["_count"];
_count = if (isArray (_config >> "count")) then { floor random getArray (_config >> "count") } else {1};

player globalChat format ["%1", _count];
for "_i" from 1 to _count do {
	private["_min", "_max", "_mid", "_target", "_kit"];
	_target = random(_summ);
	_min = 0; _max = count _array -1;

	while { _min != _max-1 } do {
		_mid = floor/*TODO*/ (_min + (_max - _min) / 2);
		player globalChat format ["(%1, %2), mid: %3, target: %4", _min, _max, _array select _mid select 0, _target];
		if ( (_array select _mid select 0) <= _target )
			then { _min = _mid }
			else { _max = _mid };
	};

	_kit = _array select _max select 1;

	if (isArray (_kit >> "weapons")) then { { _box addWeaponCargoGlobal [_x, 1] } forEach getArray (_kit >> "weapons") };
	if (isArray (_kit >> "magazines")) then { { _box addMagazineCargoGlobal _x } forEach getArray (_kit >> "magazines") };
	if (isArray (_kit >> "items")) then { { _box addItemCargoGlobal _x } forEach getArray (_kit >> "items") };
	if (isArray (_kit >> "backpacks")) then { { _box addBackpackCargoGlobal [_x, 1] } forEach getArray (_kit >> "backpacks") };
};

/*
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
