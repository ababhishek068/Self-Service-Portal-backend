Table 50795 "Hr Pension Payments"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Description = 'Stores the reference of the payment voucher in the database';
            NotBlank = false;
        }
        field(2; "Date Collected"; Date)
        {
            Description = 'Stores the date when the payment voucher was inserted into the system';
        }
        field(4; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(5; Payee; Text[100])
        {
            Description = 'Stores the name of the person who received the money';
        }
        field(6; "On Behalf Of"; Text[100])
        {
            Description = 'Stores the name of the person on whose behalf the payment voucher was taken';
        }
        field(7; Cashier; Code[20])
        {
            Description = 'Stores the identifier of the cashier in the database';
        }
        field(8; Status; Option)
        {
            Description = 'Stores the status of the record in the database';
            OptionCaption = 'Pending,In Progress,Processed,Paid';
            OptionMembers = Pending,"In Progress",Processed,Paid;
        }
        field(9; "No. Series"; Code[20])
        {
            Description = 'Stores the number series in the database';
        }
        field(10; "Cheque No."; Code[20]) { }
        field(11; "Pay Mode"; Option)
        {
            OptionMembers = " ",Cash,Cheque,EFT;
        }
        field(12; "Collected By"; Option)
        {
            OptionCaption = ' ,Self,Other';
            OptionMembers = " ",Self,Other;
        }
        field(13; "Benefit Type"; Option)
        {
            OptionCaption = ' ,Insuarance,Pension,Pension,Gratuity';
            OptionMembers = " ",Insuarance,Pension,Gratuity;
        }
        field(14; "Name of Insurance"; Text[50]) { }
        field(15; "ID Number"; Code[8]) { }
        field(16; Amount; Decimal) { }
        field(17; Principal; Code[20])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                Hremp.SetRange(Hremp."No.", Principal);
                if Hremp.Find('-') then begin
                    "Principal's Names" := Hremp."First Name" + ' ' + Hremp."Middle Name" + ' ' + Hremp."Last Name";
                end;
            end;
        }
        field(18; "Principal's Names"; Text[30])
        {
            Editable = false;
        }
        field(19; "Date Prepared"; Date) { }
        field(20; "Collected By (Name)"; Text[50]) { }
        field(50000; "Employee Type"; Option)
        {
            OptionCaption = 'Permanent,Casuals,Contract';
            OptionMembers = Permanent,Casuals,Contract;
        }
        field(50001; "Employee Terms Of Service"; Option)
        {
            OptionCaption = 'Temporary Appointment,Designee,Consultant,Pre-Service trainee';
            OptionMembers = "Temporary Appointment",Designee,Consultant,"Pre-Service trainee";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Pension Nos.");
            "No.":=NoseriesMgt.GetNextNo(HRSetup."Pension Nos.", 0D,true);
        end;

        "Date Prepared" := Today;
    end;

    var
        Hremp: Record "HR-Employee";
        HRSetup: Record "HR Setup";
        NoseriesMgt: Codeunit "No. Series";
}

