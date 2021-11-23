#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>

#define PLUGIN "Fall Damage"
#define VERSION "1.21"
#define AUTHOR "Psycrow"

#define IsPlayer(%0) (1<=%0<=g_iMaxPlayers)

new g_iMaxPlayers, Float: g_fMulAttacker, Float: g_fMulVictim

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)
    
    // fall damage reduction (taken damage * cvar value)
    bind_pcvar_float(register_cvar("n21_falldamage_mul_attacker", "0.4"), g_fMulAttacker)

    // damage to the victim that fell (taken damage * cvar value)
    bind_pcvar_float(register_cvar("n21_falldamage_mul_victim", "0.9"), g_fMulVictim)
    
    RegisterHam(Ham_TakeDamage, "player", "HAM_PlayerTakeDamage_Pre")
    
    g_iMaxPlayers = get_maxplayers()
}

public HAM_PlayerTakeDamage_Pre(iVictim, iInflictor, iAttacker, Float: fDamage, bits)
{
    if (bits & DMG_FALL)
    {
        new iGroundEnt = pev(iVictim, pev_groundentity)

        if (!IsPlayer(iGroundEnt))
            return HAM_IGNORED

        ExecuteHamB(Ham_TakeDamage, iGroundEnt, iVictim, iVictim, fDamage * g_fMulVictim, DMG_FALL)
        SetHamParamFloat(4, fDamage * g_fMulAttacker)
        return HAM_OVERRIDE
    }
    
    return HAM_IGNORED
}
