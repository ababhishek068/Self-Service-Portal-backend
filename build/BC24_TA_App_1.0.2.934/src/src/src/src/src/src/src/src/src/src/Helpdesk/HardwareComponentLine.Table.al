#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50997 "Hardware Component Line"
{

    fields
    {
        field(1;"Part No";Code[30])
        {
            TableRelation = "ATM Hardware components"."Part No";

            trigger OnValidate()
            begin
                ObjAtmreg.SetRange(ObjAtmreg."Requestion No","Atm No");
                if ObjAtmreg.Find('-') then
                  if ObjAtmreg."Part Category"<>ObjAtmreg."part category"::Hardware then
                    Error('Part category must be Hardware');
                  if ATMHRD.Get("Part No")then
                  Description:=ATMHRD.Description;
            end;
        }
        field(2;Description;Text[50])
        {
        }
        field(3;Quantity;Integer)
        {
        }
        field(4;"Unit price";Decimal)
        {

            trigger OnValidate()
            begin
                "Total Amount":=Quantity*"Unit price";
            end;
        }
        field(5;"Atm No";Code[30])
        {
            TableRelation = "ATM Register."."ATM No";
        }
        field(6;"Total Amount";Decimal)
        {
        }
        field(7;Category;Option)
        {
            OptionMembers = Hardware;
        }
        field(8;"Entry No";Integer)
        {
        }
        field(10;Status;Option)
        {
            OptionCaption = 'Working,Faulty,Repaired,Beyond Repaire';
            OptionMembers = Working,Faulty,Repaired,"Beyond Repaire";
        }
        field(11;"Requestion No";Code[10])
        {
            TableRelation = "ATM Requestion Register"."Requestion No";
        }
        field(12;"Requestion Send";Boolean)
        {
        }
        field(13;Barcode;Code[10])
        {

            trigger OnValidate()
            begin
                Itemx.Reset;
                Itemx.SetRange(Itemx."Serial No",Barcode);
                if Itemx.Find('-')then begin
                  "Part No":=Itemx."Part No";
                  end;
            end;
        }
        field(14;"Case No";Code[20])
        {
        }
        field(15;Type;Option)
        {
            OptionCaption = ',ATM,Kiosk';
            OptionMembers = ,ATM,Kiosk;
        }
        field(16;"to bill";Boolean)
        {
        }
        field(17;compulsory;Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Requestion No","Entry No","Part No",Barcode)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ATMHRD: Record "Logical Framework";
        ObjAtmreg: Record "ATM Requestion Register";
        Itemx: Record Item;
}

