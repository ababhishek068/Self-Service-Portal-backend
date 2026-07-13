#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51000 "ATM Hardware components"
{
    DrillDownPageID = "Logical Framework Outcome";
    LookupPageID = "Logical Framework Outcome";

    fields
    {
        field(1;"Part No";Code[30])
        {

            trigger OnValidate()
            begin
                if "Serial No"='' then
                  begin
                    itemsrec.Reset;
                    itemsrec.SetRange(itemsrec."Part No","Part No");
                    "Serial No":=itemsrec."Serial No";
                    end;
            end;
        }
        field(2;Description;Text[50])
        {
        }
        field(3;"Serial No";Code[30])
        {

            trigger OnValidate()
            begin
                itemsrec.Reset;
                itemsrec.SetRange(itemsrec."Serial No","Serial No");
                if itemsrec.Find('-')then
                  begin
                    "Part No":=itemsrec."Part No";
                    end;
            end;
        }
        field(4;"ATM No";Code[10])
        {
        }
        field(5;Type;Option)
        {
            OptionCaption = ',ATM,Kiosk';
            OptionMembers = ,ATM,Kiosk;
        }
        field(6;"entry no";Integer)
        {
            AutoIncrement = true;
        }
        field(7;"Total Quantity";Integer)
        {
            CalcFormula = sum("Component Line Register".Quantity where ("Part No"=field("Part No"),
                                                                        "Part status"=filter(Issued)));
            FieldClass = FlowField;
        }
        field(8;Counter;Integer)
        {
        }
        field(9;"Show Engineer";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Part No")
        {
            Clustered = true;
        }
        key(Key2;"Serial No")
        {
        }
        key(Key3;"entry no")
        {
        }
    }

    fieldgroups
    {
    }

    var
        itemsrec: Record Item;
}

