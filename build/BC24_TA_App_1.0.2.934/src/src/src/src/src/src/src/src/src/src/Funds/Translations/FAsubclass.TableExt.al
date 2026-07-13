namespace ABH_UAT.ABH_UAT;

using Microsoft.FixedAssets.Setup;

tableextension 50051 FAsubclass extends "FA Subclass"
{
    fields
    {
        field(50000; "Residue(%)"; Decimal)
        {
            Caption = 'Residue(%)';
            DataClassification = ToBeClassified;
        }
    }
}
