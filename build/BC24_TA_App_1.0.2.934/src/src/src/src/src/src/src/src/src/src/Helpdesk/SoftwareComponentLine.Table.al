#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50996 "Software Component Line"
{

    fields
    {
        field(1;"Code";Code[10])
        {
            TableRelation = "ATM Software components".Code;

            trigger OnValidate()
            begin
                ObjAtmreg.SetRange(ObjAtmreg."Requestion No",Atm_No);
                if ObjAtmreg.Find('-') then
                  if ObjAtmreg."Part Category"<>ObjAtmreg."part category"::Software then
                    Error('Part category must be software');
                  if ATMHRD.Get(Code)then
                  Description:=ATMHRD.Description;
            end;
        }
        field(2;Description;Text[50])
        {
        }
        field(3;Cost;Decimal)
        {
        }
        field(4;Atm_No;Code[10])
        {
        }
    }

    keys
    {
        key(Key1;Atm_No,"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ObjAtmreg: Record "ATM Requestion Register";
        ATMHRD: Record "ATM Software components";
}

