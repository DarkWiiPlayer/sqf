/*
Author: DarkWiiPlayer
Description: Adds a visual overlay to the player when they put on certain facewear
License: Unlicense
Parameters:
	- Player
*/

if (!canSuspend) exitWith {};

params [
	["_player", objNull, [objNull]]
];

while {true} do {
	private _target = if (isNull _player) then { player } else { _player };
	private _goggles = goggles _target;
	switch (_goggles) do {
		case "G_AirPurifyingRespirator_01_F";
		case "G_AirPurifyingRespirator_01_nofilter_F":
		{ "facewear" cutRsc ["RscCBRN_APR", "PLAIN", -1, false] };

		case "G_AirPurifyingRespirator_02_black_F";
		case "G_AirPurifyingRespirator_02_olive_F";
		case "G_AirPurifyingRespirator_02_sand_F":
		{ "facewear" cutRsc ["RscCBRN_APR_02", "PLAIN", -1, false] };

		case "G_RegulatorMask_F":
		{ "facewear" cutRsc ["RscCBRN_Regulator", "PLAIN", -1, false] };

		case "G_Blindfold_01_black_F";
		case "G_Blindfold_01_white_F":
		{ "facewear" cutRsc ["RscBlindfold", "PLAIN", -1, false] };

		default { "facewear" cutText ["", "PLAIN"]; };
	};
	waitUntil { _goggles != goggles _target };
}

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
