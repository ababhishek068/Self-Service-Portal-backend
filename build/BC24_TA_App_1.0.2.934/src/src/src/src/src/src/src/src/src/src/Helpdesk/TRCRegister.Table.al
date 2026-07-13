#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51005 "TRC Register"
{

    fields
    {
        field(1;"TRC No";Code[10])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "TRC No" <> xRec."TRC No" then
                  begin
                    Trcgensetup.Get();
                    Noseriesmgt.TestManual(Trcgensetup."TRC Nos");
                    "No. Series":= '';
                    end;
            end;
        }
        field(2;Description;Text[30])
        {
        }
        field(3;"ATM No";Code[20])
        {
            TableRelation = Item."No." where ("Item Category Code"=filter('ATM'));

            trigger OnValidate()
            begin
                if atmdetails.Get("ATM No") then
                "Serial Number":= atmdetails."Serial No";
                "Part No":=atmdetails."Part No";
                "Atm Description":= atmdetails.Description;
            end;
        }
        field(4;"Serial Number";Code[10])
        {
        }
        field(5;"Part No";Code[30])
        {
        }
        field(6;"Atm Description";Text[50])
        {
        }
        field(7;"Engineer No";Code[10])
        {
            TableRelation = "HR-Employee"."No.";
             trigger OnValidate()
            begin
                if engineer.Get("Engineer No") then
                  "Engineer Name":=engineer."First Name"+' '+engineer."Last Name";

            end;
        }
        field(8;"Engineer Name";Text[50])
        {
        }
        field(9;"Reparing Engineer Name";Text[50])
        {
        }
        field(10;"Customer No";Code[10])
        {
            TableRelation = Customer."No." where ("Customer Posting Group"=filter('ATM'));

            trigger OnValidate()
            begin
                if Cust.Get("Customer No") then
                  "Customer Name":=Cust.Name;
            end;
        }
        field(11;"Customer Name";Text[50])
        {
        }
        field(12;Solution;Option)
        {
            OptionCaption = ',Repair,Replace';
            OptionMembers = ,Repair,Replace;
        }
        field(13;"Delivered On";Date)
        {
        }
        field(14;"Created By";Code[20])
        {
        }
        field(15;"Created Date";Date)
        {
            Editable = false;
        }
        field(16;"Created Time";Time)
        {
            Editable = false;
        }
        field(17;"No. Series";Code[10])
        {
        }
        field(18;"Reparing Enginee No";Code[10])
        {
            Editable = true;
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            begin
                if engineer.Get("Reparing Enginee No") then
                  "Reparing Engineer Name":=engineer."First Name"+'' +engineer."Last Name";
            end;
        }
        field(19;"Engineer Findings";Text[250])
        {
        }
        field(20;"Description 2";Blob)
        {
        }
        field(21;Status;Option)
        {
            OptionCaption = 'open,repaired,beyond repair';
            OptionMembers = open,repaired,"beyond repair";
        }
        field(22;Created;Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"TRC No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "TRC No" = '' then begin
        Trcgensetup.Get;
        Trcgensetup.TestField(Trcgensetup."TRC Nos");
        "TRC No":=Noseriesmgt.GetNextNo(Trcgensetup."TRC Nos",today,true);

        "Created By":=UserId;
        "Created Date":=Today;
        "Created Time":=Time;
        end;
    end;

    trigger OnRename()
    begin
        Error('testing');
    end;

    var
        Cust: Record Customer;
        Noseriesmgt: Codeunit "No. Series";
        Trcgensetup: Record "HR Setup";
        engineer: Record "HR-Employee";
        atmdetails: Record Item;
}

