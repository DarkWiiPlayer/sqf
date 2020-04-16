/*
Author: DarkWiiPlayer
Description: Calculates a players protection against a given type of environmental hazzard
License: MIT
Parameters:
	- Type
	- Player
*/

params [
	["_type", "chemical", [""]],
	["_player", player, [objNull]]
];

private _config = missionConfigFile >> "CfgCBRN";
private _protection = 0;

private _distribution = _config >> "Distribution" >> _type;
if (isClass _distribution) then {
	private _summ = getNumber (_distribution >> "uniform") + getNumber (_distribution >> "goggles") + getNumber (_distribution >> "backpack");
	_distribution = [
		getNumber (_distribution >> "uniform"),
		getNumber (_distribution >> "goggles"),
		getNumber (_distribution >> "backpack")
	] apply { _x / _summ };
} else {
	_distribution = [1, 1, 1];
};

{
	private _itemProtection = _config >> "Protection" >> (_x select 0) >> _type;
	_protection = _protection + (getNumber _itemProtection) * (_x select 1);
} forEach [
	[uniform  _player, _distribution select 0],
	[goggles  _player, _distribution select 1],
	[backpack _player, _distribution select 2]
];

0 max _protection min 1;

/*
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
