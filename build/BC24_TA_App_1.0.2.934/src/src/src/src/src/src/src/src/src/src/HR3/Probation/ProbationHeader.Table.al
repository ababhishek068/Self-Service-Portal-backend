table 50956 "Probation Header"
{
    Caption = 'Probation Header';
    DataClassification = ToBeClassified;
    DrillDownPageId="Probation List";
    LookupPageId="Probation List";
    
     fields
    {
        field(1;"Employee No";Code[20])
        {
            TableRelation = "HR-Employee"."No." where(Status=const(Active));

            trigger OnValidate()
            begin
                
                if EmpRec.Get("Employee No") then begin
                    if EmpRec."On Probation"=true then begin
                        // Error('The employee has not finished probation period');
                        Message('The employee has not finished probation period');

                    end else if EmpRec."On Probation"=false then begin
                        

                    end;
                // "Global Dimension 1 Code":=EmpRec."Global Dimension 1 Code";
                // "Global Dimension 2 Code" := EmpRec."Global Dimension 2 Code";
                // "Global Dimension 3 Code" := EmpRec."Global Dimension 3 Code";
                 "Mobile No":=EmpRec."Cell Phone Number";
                "Employment Date":=EmpRec."Date Of Joining the Company";
                "Employee Name" := EmpRec."Last Name"+' '+EmpRec."First Name"+' '+EmpRec."Middle Name";
                "Job Title" := EmpRec."Job Title";
                "Job ID":=EmpRec."Job ID";
                //Validate(Manager,EmpRec."Supervisor No.");
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
        field(19;"Activity Brief";text[250])
        {

        }
        field(20;"Weak Points";text[250])
        {

        }
        field(21;"Employ Permanently?";Boolean){}
        field(22;"Reason";Text[100]){}
        field(23;"HR Comments";text[250]){}
        field(24;"Average Score";Decimal){}
        field(25;"Requestor ID";Code[50]){}
        field(26;"Job ID";code[20]){
            TableRelation="HR Jobs"."Job ID";
        }
        field(27;"Probation Code";code[20]){


        }

    }
    

    keys
    {
        key(Key1;"Probation Code","Employee No","Job ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        // hrsetup.Get();

        if "Probation Code" = '' then begin
            hrsetup.Get;
            
                hrsetup.TestField(hrsetup."Probation Nos.");
                "Probation Code" := NoSeriesMgt.GetNextNo(hrsetup."Probation Nos.", Today, true);
            
        end;

        // "Probation Code":=getnex
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
        NAVemp: Record "HR-Employee";
        EmpRec: Record "HR-Employee";
        hrsetup: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
}

