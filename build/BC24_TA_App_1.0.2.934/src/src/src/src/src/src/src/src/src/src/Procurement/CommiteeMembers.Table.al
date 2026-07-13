#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50949 "Commitee Members"
{

    fields
    {
        field(1;"Ref No";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Quote Header"."No." where("Document Type"=const("Open Tender"));
        }
        field(2;Commitee;Code[10])
        {
            DataClassification = ToBeClassified;
            NotBlank = false;
            TableRelation = "Procurement Commitee";
        }
        field(3;"Employee No";Code[10])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                  if Empl.Get("Employee No") then
                  begin
                     Name:=Empl."First Name"+ ' ' +Empl."Last Name";
                  end;
            end;
        }
        field(4;Name;Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Appointment No";Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                  if Appoitment.Get("Appointment No") then
                  begin
                   "Appointment No":=Appoitment."Appointment No";
                    Commitee:=Appoitment."Committee ID";
                  end;
            end;
        }
        field(6;Chair;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7;Secretary;Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Appointment No","Employee No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Empl: Record Employee;
        Appoitment: Record "Tender Commitee Appointment";
}

