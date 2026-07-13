#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50946 "Staff Orientation Header"
{

    fields
    {
        field(1;"Employee No";Code[20])
        {
            TableRelation = "HR-Employee"."No." where(Status=const(Active));

            trigger OnValidate()
            begin
                
                if NAVemp.Get("Employee No") then begin
                "Mobile No":=NAVemp."Mobile Phone No.";
                "Employment Date":=NAVemp."Employment Date";
                "Employee Name" := NAVemp."Last Name"+' '+NAVemp."First Name"+' '+NAVemp."Middle Name";
                "Job Title" := NAVemp."Job Title";
                Validate(Manager,NAVemp."Manager No.");
                end;
            end;
        }
        field(2;Date;Date)
        {
        }
        field(3;"Employee Name";Text[100])
        {
            Editable = false;
        }
        field(4;"Job Title";Text[50])
        {
        }
        field(5;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(6;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(7;"Global Dimension 3 Code";Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Global Dimension 3 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(3));
        }
        field(8;Manager;Code[20])
        {   TableRelation="HR-Employee"."No." where ("Is HOD"=const(true),Status=const(Active));

            trigger OnValidate()
            begin
                if NAVemp.Get(Manager) then
                "Manager's Name" := NAVemp."First Name"+' '+NAVemp."Last Name";
            end;
        }
        field(9;"Manager's Name";Text[100])
        {
        }
        field(10;"Created By";Code[20])
        {
        }
        field(11;"Mobile No";Text[20])
        {
        }
        field(12;"Employment Date";Date)
        {
        }
        field(13;"Due Date";Date)
        {
        }
        field(14;Status;Option)
        {
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Rejected';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Rejected;
        }
        field(15;Closed;Boolean)
        {

            trigger OnValidate()
            begin
                /*"Closed By" := USERID;
                "Closed Date" := TODAY;*/

            end;
        }
        field(16;"Closed By";Code[50])
        {
        }
        field(17;"Closed Date";Date)
        {
        }
        field(18;"Hr Created";Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    

    keys
    {
        key(Key1;"Employee No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Date:=Today;
        "Created By":=UserId;

        if not "Hr Created" then begin
          if UserSetup.Get(UserId) then
          begin
           "Employee No":=UserSetup."Employee No.";
           Validate("Employee No");
          end else
          Error(Text000);
        end;
    end;

    var
        UserSetup: Record "User Setup";
        Text000: label 'Your are not mapped to an employee account. Kindly contact the system administrator.';
        NAVemp: Record Employee;
        EmpRec: Record "HR-Employee";
}

