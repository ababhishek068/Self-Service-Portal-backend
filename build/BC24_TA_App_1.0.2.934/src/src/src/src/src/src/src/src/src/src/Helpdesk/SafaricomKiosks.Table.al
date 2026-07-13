#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50993 "Safaricom Kiosks"
{
    DrillDownPageID = "Int. Auditee Noti. Card";
    LookupPageID = "Int. Auditee Noti. Card";

    fields
    {
        field(1;"Kiosk No";Code[10])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "Kiosk No"<> xRec."Kiosk No" then begin
                 ATMSetup.Get;
                  NoSeriesMgt.TestManual(ATMSetup."ATM Nos");
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
        field(5;"Customer No";Code[10])
        {
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                 if cust.Get("Customer No") then
                   "Customer Name":=cust.Name;
            end;
        }
        field(6;"Customer Name";Text[50])
        {
        }
        field(7;country;Code[30])
        {
            TableRelation = "Country/Region".Code;
        }
        field(8;Branch;Code[50])
        {
        }
        field(9;Street;Code[30])
        {
        }
        field(10;"Physical loation";Text[150])
        {
        }
        field(11;"Part Category";Option)
        {
            BlankZero = true;
            OptionCaption = ',Hardware,Software';
            OptionMembers = ,Hardware,Software;
        }
        field(12;"No. Series";Code[20])
        {
        }
        field(13;"Responsible Engineer ID";Code[10])
        {
            TableRelation = "HR-Employee"."No.";
                        trigger OnValidate()
            begin
                if hrenginer.Get("Responsible Engineer ID")then
                  "Engineer Name":=hrenginer."Full Name";
            end;
        }
        field(14;"Engineer Name";Text[30])
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
        field(18;"Kiosk model code";Code[50])
        {

            trigger OnValidate()
            begin
                /*IF Atmmodule.GET("ATM model code") THEN BEGIN
                "Atm model":=Atmmodule."ATM Model";
                "Atm Dimensions":=Atmmodule.Dimension;
                "Camera Installed":=Atmmodule."Camera Installed";
                Cassettes:=Atmmodule.cassettes;
                "Receipt Printer":=Atmmodule."Receipt Printer";
                "Touch Screen":=Atmmodule."Touch Screen";
                "Screen Size":=Atmmodule."Screen Size";
                END;*/

            end;
        }
        field(19;"Kiosk model";Text[50])
        {
        }
        field(20;"Kiosk Dimensions";Code[30])
        {
        }
        field(21;"Camera Installed";Option)
        {
            OptionMembers = ,Yes,Nos;
        }
        field(22;Cassettes;Code[10])
        {
        }
        field(23;"Receipt Printer";Code[50])
        {
        }
        field(24;"Touch Screen";Option)
        {
            OptionCaption = ',Yes,No';
            OptionMembers = ,Yes,No;
        }
        field(25;"Screen Size";Code[30])
        {
        }
        field(26;"Kiosk Status";Option)
        {
            OptionCaption = 'Active,Inactive,Relocated';
            OptionMembers = Active,Inactive,Relocated;
        }
        field(27;"Total Spares In Hand";Integer)
        {
            FieldClass = Normal;
        }
        field(28;"Faulty Spares";Integer)
        {
            FieldClass = Normal;
        }
        field(29;"Repared Spares";Integer)
        {
            FieldClass = Normal;
        }
        field(30;"Kiosk Invoices";Integer)
        {
        }
        field(31;"Total Cost";Decimal)
        {
            FieldClass = Normal;
        }
        field(32;"Kiosk code";Code[20])
        {
        }
        field(33;latitude;Code[50])
        {
        }
        field(34;longitude;Code[50])
        {
        }
        field(35;"weekday opening";Time)
        {
        }
        field(36;"weekday closing";Time)
        {
        }
        field(37;"Store address";Text[100])
        {
        }
        field(38;"weekday and holidays";Text[100])
        {
        }
    }

    keys
    {
        key(Key1;"Kiosk No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Kiosk No" = '' then begin
          ATMSetup.Get;
          ATMSetup.TestField(ATMSetup."ATM Nos");
          "Kiosk No":=NoSeriesMgt.GetNextNo(ATMSetup."ATM Nos",Today,true);
          "Requestion date":=Today;
          "Created By":=UserId;
        end;
    end;

    var
        ATMSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
        hrenginer: Record "HR-Employee";
        cust: Record Customer;
        Atmmodule: Record "ATM Model Setup";
}

