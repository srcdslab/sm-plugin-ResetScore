#include <sourcemod>
#include <sdktools>

#include <multicolors>

#pragma tabsize 0
#pragma newdecls required

ConVar g_cvEnableRs;

public Plugin myinfo =
{
	name = "ResetScore",
	author = "ire.",
	description = "Reset your score",
	version = "1.1.0",
};

public void OnPluginStart()
{
	LoadTranslations("resetscore.phrases");

	g_cvEnableRs = CreateConVar("sm_rs_enabled", "1", "Enable or disable plugin");

	RegConsoleCmd("sm_rs", ResetScore);
	RegConsoleCmd("sm_resetscore", ResetScore);

	AutoExecConfig();
}

public Action ResetScore(int client, int args)
{
	if (!g_cvEnableRs.BoolValue)
	{
		CPrintToChat(client, "%t", "RsDisabled");
		return Plugin_Handled;
	}

	if (GetEntProp(client, Prop_Data, "m_iFrags") == 0 && GetEntProp(client, Prop_Data, "m_iDeaths") == 0)
	{
		CPrintToChat(client, "%t", "NoScore");
	}
	else
	{
		SetEntProp(client, Prop_Data, "m_iFrags", 0);
		SetEntProp(client, Prop_Data, "m_iDeaths", 0);
		CPrintToChat(client, "%t", "ScoreReseted");
	}
	return Plugin_Handled;
}
