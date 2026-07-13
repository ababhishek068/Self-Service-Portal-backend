#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51004 "Store Requestion  Register"
{
    DrillDownPageID = "Logical Framework Activity";
    LookupPageID = "Logical Framework Activity";

    fields
    {
        field(1;"PR No";Code[10])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "PR No" <> xRec."PR No" then begin
                 ATMSetup.Get;
                  NoSeriesMgt.TestManual(ATMSetup."Store Nos");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;Description;Text[50])
        {
        }
        field(3;"Serial Number";Code[30])
        {
        }
        field(4;"Requestion date";Date)
        {
        }
        field(5;"Main Store";Code[10])
        {
            TableRelation = Location.Code;

            trigger OnValidate()
            begin
                 if cust.Get("Main Store") then
                   "Main  Name":=cust.Name;
            end;
        }
        field(6;"Main  Name";Text[50])
        {
        }
        field(7;country;Code[30])
        {
            TableRelation = "Country/Region".Code;
        }
        field(8;Branch;Code[30])
        {
            TableRelation = "Post Code".City;
        }
        field(9;Street;Code[30])
        {
        }
        field(10;"Physical loation";Text[30])
        {
        }
        field(11;"Part Category";Option)
        {
            BlankZero = true;
            OptionCaption = ',Full package,component package';
            OptionMembers = ,"Full package","component package";
        }
        field(12;"No. Series";Code[20])
        {
        }
        field(13;"Requesting Store";Code[10])
        {
            TableRelation = Location.Code;

            trigger OnValidate()
            begin
                if hrenginer.Get("Requesting Store")then
                  "Requester  Name":=hrenginer.Name;
            end;
        }
        field(14;"Requester  Name";Text[30])
        {
        }
        field(15;"Created By";Code[30])
        {
            Editable = false;
        }
        field(16;Created;Boolean)
        {
            Editable = false;
        }
        field(17;"Requestion Send";Boolean)
        {
        }
        field(18;Corrected;Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"PR No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "PR No" = '' then begin
          ATMSetup.Get;
          ATMSetup.TestField(ATMSetup."Store Nos");
          "PR No":=NoSeriesMgt.GetNextNo(ATMSetup."Store Nos",today,true);
          "Requestion date":=Today;
          "Created By":=UserId;
        end;
    end;

    var
        ATMSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
        hrenginer: Record Location;
        cust: Record Location;
}

