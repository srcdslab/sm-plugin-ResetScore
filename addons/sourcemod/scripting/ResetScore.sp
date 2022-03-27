#include <sourcemod>
#include <sdktools>

#pragma tabsize 0

ConVar g_cvEnableRs;

public Plugin myinfo =
{
	name = "ResetScore",
	author = "ire.",
	description = "Reset your score",
	version = "1.0",
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_rs", ResetScore);
	RegConsoleCmd("sm_resetscore", ResetScore);
	g_cvEnableRs = CreateConVar("sm_rs_enabled", "1", "Enable or disable plugin");
	AutoExecConfig();
	LoadTranslations("resetscore.phrases");
}

public Action ResetScore(int client, int args)
{
	if(!g_cvEnableRs.BoolValue)
	{
        PrintToChat(client, "%t", "RsDisabled");
        return Plugin_Handled;		
	}
    if(GetEntProp(client, Prop_Data, "m_iFrags") == 0 && GetEntProp(client, Prop_Data, "m_iDeaths") == 0)
    {
        PrintToChat(client, "%t", "NoScore");
        return Plugin_Handled;
    }
    else
    {
	    SetEntProp(client, Prop_Data, "m_iFrags", 0);
		SetEntProp(client, Prop_Data, "m_iDeaths", 0);
        PrintToChat(client, "%t", "ScoreReseted");
        return Plugin_Handled;
    }
}