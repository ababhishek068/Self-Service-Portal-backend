namespace ABH_UAT.ABH_UAT;

using Microsoft.FixedAssets.Setup;

pageextension 50067 FAsubclasses extends "FA Subclasses"
{
   layout
   {
    addafter("Default FA Posting Group")
    {
        field("Residue(%)";"Residue(%)")
        {ApplicationArea=basic;
        }
    }
   }

}
