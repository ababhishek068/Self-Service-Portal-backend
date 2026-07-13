Table 50924 "Internal Employment History"
{
    LookupPageID ="Internal Emp History Lines";
    //50924
    fields
    {
        field(1; "Employee No."; Code[20])
        {
            NotBlank = false;
            TableRelation = "HR-Employee"."No.";
        }
        field(2; From; Date)
        {
            NotBlank = false;
        }
        field(3; "To Date"; Date)
        {
            NotBlank = false;
        }
        field(4; "Company Name"; Text[150])
        {
            NotBlank = false;

        }
        field(6; "Reason for Change"; Option)
        {
            OptionMembers = Promotion,Demotion,Transfer,Employment,"Acting Position","Temporary Position",Delegation;
            OptionCaption = 'Promotion,Demotion,Transfer,Employment,Acting Position,Temporary Position,Delegation';
        }

        field(20; "Job ID"; Code[30])
        {
            Description = 'To put description on Job title field';
            TableRelation = "HR Jobs"."Job ID";
            trigger OnValidate()
            var
                HRJobs: Record "HR Jobs";
            BEgin
                Clear("Job Title");
                if HRJobs.Get("Job ID") then "Job Title" := hrjobs."Job Description";
            end;

        }
        field(9; Sector; code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            trigger OnValidate()
            begin
                // Clear("Global Dimension 3 Code");
                // Clear("Global Dimension 2 Code");
                // Clear(District);
                // Clear(Division);
            end;
        }
        field(10; District; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Departments."Department Code" where("Sector Code" = field(Sector), level = const(District));

            trigger OnValidate()
            begin
                // TestField(Sector);
                // Clear(Division);
                // Clear("Global Dimension 3 Code");
                // Clear("Global Dimension 2 Code");
                // departmentsRec.Reset();
                // departmentsRec.SetRange(departmentsRec."Department Code", "Global Dimension 2 Code");
                // departmentsRec.SetRange(departmentsRec.level, departmentsRec.level::District);
                // if departmentsRec.FindFirst() then begin

                //     Sector := departmentsRec."Sector Code";
                // end;
            end;
        }
        field(48;"Global Dimension 1 Code";code[20]){
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

        }
        field(11; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Department';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            //TableRelation = Departments."Department Code" where("Sector Code" = field(Sector), level = const(Department));
            trigger OnValidate()
            begin
                // TestField(Sector);
                // TestField(Sector);
                // Clear(Division);
                // Clear("Global Dimension 3 Code");

                // Clear(District);
                // departmentsRec.Reset();
                // departmentsRec.SetRange(departmentsRec."Department Code", "Global Dimension 2 Code");
                // departmentsRec.SetRange(departmentsRec.level, departmentsRec.level::Department);
                // if departmentsRec.FindFirst() then begin

                // end;

            end;
        }
        field(12; "Global Dimension 3 Code"; Code[20])
        {

            Caption = 'Work Station';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            //TableRelation = Branches."Division/Branch Code" where("Department/District Code" = field(District), level = const(Branch), "Sector Code" = field(Sector));

            trigger OnValidate()
            var

            begin
                // TestField(Sector);
                // TestField(District);
                // //clear("Branch Grade");
                // Clear("Global Dimension 2 Code");
                // Clear(Division);
                // branchesdivRec.Reset();
                // branchesdivRec.SetRange(branchesdivRec."Department/District Code", District);
                // branchesdivRec.SetRange(branchesdivRec.level, branchesdivRec.level::Branch);
                // if branchesdivRec.FindFirst() then begin
                //     branchgrade.Reset();
                //     branchgrade.SetRange(branchgrade."Branch Code", "Global Dimension 3 Code");
                //     if branchgrade.FindFirst() then begin

                //     end;
                // end;


            end;
        }
        field(13; Division; code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            //TableRelation = Branches."Division/Branch Code" where("Department/District Code" = field("Global Dimension 2 Code"), level = const(Division), "Sector Code" = field(Sector));
            trigger OnValidate()
            begin
                // TestField("Global Dimension 2 Code");
                // TestField(Sector);
                // branchesdivRec.Reset();
                // branchesdivRec.SetRange(branchesdivRec."Division/Branch Code", Division);
                // branchesdivRec.SetRange(branchesdivRec.level, branchesdivRec.level::Division);
                // if branchesdivRec.FindFirst() then begin
                //     branchesdivRec.TestField("Sector Code");
                //     branchesdivRec.TestField("Department/District Code");
                //     Clear("Global Dimension 3 Code");
                //     Clear(District);
                //     Clear(branchgrade);
                // end else if not branchesdivRec.Find() then begin
                //     Error('Division does not exists on the organogram');

                // end;
            end;
        }
        field(14; "Work Station"; Code[20])
        {
            //TableRelation = Branches."Division/Branch Code" where(level = const(Branch));
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            trigger OnValidate()
            begin

            end;
        }
        field(29; Grade;Integer)
        {

            // TableRelation = "HR Job Grades".Code;
            TableRelation = "Sal Grades"."Salary Grade";
            //testfield(global di)        


        }
        field(30; Status; Option)
        {
            OptionMembers = New,"Pending Approval",Approved,Rejected;



        }
        field(31; Promotion_No; code[20]) { }
        field(32; current; Boolean)
        {

            trigger OnValidate()
            var
                myInteger: Integer;

            begin
                myInteger := 0;
                interpromo.Reset();
                interpromo.SetRange(interpromo."Employee No.", "Employee No.");
                interpromo.SetRange(current, true);
                if interpromo.FindSet() then begin
                    if interpromo.Promotion_No <> Promotion_No then begin


                        interpromo.current := false;
                    end;

                end;


            end;
        }
        field(7; "Job Title"; Text[150])
        {
            editable = false;
        }
        field(8; "Key Experience"; Text[150]) { }
        field(40; "Salary On Leaving"; Decimal) { }
        field(41; "Reason Description"; Text[150]) { }

        field(42; Comment; Text[200])
        {
            Editable = true;
        }
        field(55; "Promoted to HoD"; Boolean)
        {
            editable = true;
        }
        field(56;"Ref No";code[50]){}
    }

    keys
    {
        key(Key1; "Employee No.", From, "Job ID", "Job Title")
        {
            Clustered = true;
        }
    }
    var
        DimVal: Record "Dimension Value";
        interpromo: Record "Internal Employment History";
        branchgrade: Record "Branch Grading";
        distrctsdepartRec: Record Departments;
        hrinstitutions: Record "Hr Institutions";
        branchesdivRec: Record Branches;

        departmentsRec: Record Departments;

        sectorsRec: Record Sectors;


        organogra: Record Organogram;


}


