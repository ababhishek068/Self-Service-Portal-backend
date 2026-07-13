#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50995 "Decommisioned ATMs Parts"
{

    fields
    {
        field(2;"Serial No";Code[40])
        {
        }
        field(3;Name;Text[50])
        {
        }
        field(4;Location;Text[30])
        {
        }
        field(5;"Location Type";Option)
        {
            OptionCaption = ',Lobby,Branch';
            OptionMembers = ,Lobby,Branch;
        }
        field(6;Model;Code[30])
        {
        }
        field(7;"Part No";Code[40])
        {
            TableRelation = "ATM Hardware components"."Part No";
        }
        field(8;Descr;Text[50])
        {
        }
        field(9;Quantity;Integer)
        {
        }
        field(10;"Unit Price";Decimal)
        {
        }
        field(11;Barcode;Code[10])
        {

            trigger OnValidate()
            begin
                Decommissionedlines.Reset;
                Decommissionedlines.SetRange(Decommissionedlines.Barcode,Barcode);
                if Decommissionedlines.Find('-') then begin

                  Error('This Barcode is used for '+ Decommissionedlines."Part No"+' of ATM SN: '+Decommissionedlines."Serial No");

                end;
                Status:=Status::Ok;
            end;
        }
        field(12;Status;Option)
        {
            OptionCaption = ',Ok,Faulty';
            OptionMembers = ,Ok,Faulty;
        }
        field(13;Used;Boolean)
        {
        }
        field(14;Counter;Integer)
        {
        }
        field(15;"Date Used";Date)
        {
        }
        field(16;"Requisition No";Code[20])
        {
        }
        field(17;"Location used";Text[50])
        {
        }
        field(18;"ATM used";Code[20])
        {
        }
        field(19;"ATM name used";Text[50])
        {
        }
        field(20;"Issued By";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Serial No","Part No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        componentline: Record "Component Line Register";
        Componentlinepending: Record "Component Line Register-Pendin";
        Decommissionedlines: Record "Decommisioned ATMs Parts";
        parts: Record "ATM Hardware components";
}

