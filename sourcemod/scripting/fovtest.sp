#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Diam0ndz"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <sdkhooks>

#pragma newdecls required

EngineVersion g_Game;

public Plugin myinfo = 
{
	name = "FOV Test",
	author = PLUGIN_AUTHOR,
	description = "Just an FOV test to change FOV",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/id/Diam0ndz/"
};

public void OnPluginStart()
{
	g_Game = GetEngineVersion();
	if(g_Game != Engine_CSGO && g_Game != Engine_CSS)
	{
		SetFailState("This plugin is for CSGO/CSS only.");	
	}
	RegAdminCmd("sm_fov", CMD_FovChange, ADMFLAG_BAN, "change fov");
}

public Action CMD_FovChange(int client, int args)
{
	if(args < 2 || args > 2)
	{
		PrintToChat(client, "yeah u did somethin wrong");
		return Plugin_Handled;
	}
	
	char newFov[32] = "";
	GetCmdArg(2, newFov, sizeof(newFov));
	int newFovInt = StringToInt(newFov, 10);
	
	char arg[65];
	GetCmdArg(1, arg, sizeof(arg));
	
	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS], target_count;
	bool tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_ALIVE,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	for (int i = 0; i < target_count; i++)
	{
		SetEntProp(target_list[i], Prop_Send, "m_iFOV", newFovInt);
		SetEntProp(target_list[i], Prop_Send, "m_iDefaultFov", newFovInt);
		PrintToChatAll("%s fov was set to %d by %s", target_list[i], newFovInt, client);
		return Plugin_Handled;
	}
	
	if (tn_is_ml)
	{
		ShowActivity2(client, "[SM] ", "%t", "Set FOV on target", target_name);
	}
	else
	{
		ShowActivity2(client, "[SM] ", "%t", "Set FOV on target", "_s", target_name);
	}
	return Plugin_Handled;
}
