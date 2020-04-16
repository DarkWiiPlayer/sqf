/*
Author: DarkWiiPlayer
Description: Scans the players surroundings for environmental hazard hotspots and applies negative status effects accordingly
License: MIT
Parameters:
	- Radius [100 meters]
	- Player [objNull]
	- Tick interval [1 second]
*/


if (!canSuspend) exitWith {};

params [
	["_radius", 100, [0]],
	["_player", objNull, [objNull]],
	["_tick", 1, [0]]
];

"chemical_detector" cutRsc ["RscWeaponChemicalDetector", "PLAIN", 1, false];
while { true } do {
	private _subject = if (isNull _player) then { player } else { _player };
	private _total = 0;
	_hotspots = (position _subject) nearObjects [ "logic", _radius ] select { !isNil { _x getVariable "contamination_level" } };
	{
		private _strength = 0;
		private _distance = (_subject distance _x);
		private _level = _x getVariable "contamination_level";
		private _type = (_x getVariable ["contamination_type", "chemical"]);
		switch (_type) do {
			case "chemical": {
				private _falloff = _x getVariable ["contamination_falloff", 1];
				_strength = 0 max (_level - (_distance*_falloff)^2 / _level);
				_subject setDamage (getDammage _subject) + (_strength / 1000) * (1 - ([_type, _subject] call DWP_fnc_playerProtection)) * _tick;
			};

			case "biological": { hint format ["Contamination type %1 not implemented", _type]; };

			case "radiological";
			case "nuclear": {
				private _falloff = _x getVariable ["contamination_falloff", 1];
				_strength = 0 max (_level - (_distance*_falloff)^2 / _level);
				_subject setVariable ["radiation", (_subject getVariable ["radiation", 0]) + (_strength / 100 * (1 - ([_type, _subject] call DWP_fnc_playerProtection))) * _tick];
			};

			default { hint format ["Contamination type %1 not implemented", _type]; };
		};
		_total = _total + _strength;
	} forEach _hotspots;

	private _ui = uiNamespace getVariable "RscWeaponChemicalDetector";
	private _obj = _ui displayCtrl 101;
	_obj ctrlAnimateModel ["Threat_Level_Source", (ceil _total / 10) min 9.9, true];

	private _radiation = _subject getVariable ["radiation", 0];
	if (_radiation > 1) then {
		_subject setDamage (getDammage _subject) + (_radiation / 100) * _tick;
		_subject setVariable ["radiation", (_radiation - _tick / 100) max 0 ];
	};

	sleep _tick;
}

/*
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
