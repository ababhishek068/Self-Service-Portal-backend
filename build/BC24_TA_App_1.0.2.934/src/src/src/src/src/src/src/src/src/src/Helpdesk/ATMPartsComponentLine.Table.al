Table 51002 "ATM Parts Component Line"
{

    fields
    {
        field(1;"Part No";Code[30])
        {
            TableRelation = "ATM Parts sub components".code;

            trigger OnValidate()
            begin
                if ATMHRD.Get("Part No")then
                Description:=ATMHRD.Description;
                "Entry No":="Entry No"+100;
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
            TableRelation = "TRC Register"."Part No";
        }
        field(6;"Total Amount";Decimal)
        {
        }
        field(7;Category;Option)
        {
            OptionMembers = ,Repair,Replace;
        }
        field(8;"Entry No";Integer)
        {
        }
        field(9;"Customer No";Code[10])
        {
            TableRelation = Customer."No." where ("Customer Posting Group"=filter('ATM'));

            trigger OnValidate()
            begin
                if Cust.Get("Customer No") then
                  "Customer Name":=Cust.Name;
            end;
        }
        field(10;"Customer Name";Text[50])
        {
            Editable = false;
        }
        field(11;"TRC CODE";Code[20])
        {
            TableRelation = "TRC Register"."TRC No";
        }
    }

    keys
    {
        key(Key1;"TRC CODE","Entry No","Part No","Customer No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ATMHRD: Record "ATM Parts sub components";
        ObjAtmreg: Record "ATM Requestion Register";
        Cust: Record Customer;
}

