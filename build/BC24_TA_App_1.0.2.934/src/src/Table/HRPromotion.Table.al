table 50926 HR_Promotion
{
    Caption = 'HR_Promotion';
    LookupPageId = "Promotion List";
    DrillDownPageId = "Promotion List";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Promtion_No; Code[10])
        {
            Caption = 'Promtion_No';
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            begin

                posted := false;

            end;

        }
        field(2; Employee_No; Code[10])
        {
            Caption = 'Employee_No';
            TableRelation = "HR-Employee"."No.";
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                counter1: Integer;
            begin
                hremp.reset();
                hremp.setrange(hremp."No.", Employee_No);
                if hremp.FindFirst() then begin
                    "Employee Name" := hremp."First Name" + ' ' + hremp."Middle Name" + ' ' + hremp."Last Name";
                    "Is HOD" := hremp."Is HOD";
                    posted := false;
                    "Current Gross Pay" := hremp."Curr. Gross Pay";
                    "Created By" := UserId;
                    "Date Created" := Today;
                    "Time Created" := time;
                    "Global Dimension 2 Code":=hremp."Global Dimension 2 Code";
                    "Global Dimension 3 Code":=hremp."Global Dimension 3 Code";
                    District:=hremp."Business Unit";
                    Division:=hremp.Division;
                    Sector:=hremp.Sector;
                    "Job Id":=hremp."Job ID";
                    "Salary Grade":=hremp.Grade;
                end;
                counter1 := 0;
                hrpro.Reset();
                hrpro.SetRange(hrpro.Employee_No, Employee_No);
                if hrpro.Find('-') then begin
                    repeat
                        if hrpro.Status <> hrpro.Status::Approved then begin
                            if hrpro.Status <> hrpro.Status::Rejected then begin
                                counter1 := counter1 + 1;
                            end;

                        end;

                    until hrpro.Next = 0;


                end;
                if counter1 > 1 then begin
                    Error('Same Employee has promotion/Demotion/Transfer in progress and thus cannot create new one');
                end;
            end;

        }
        field(3; "Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(4; "Job Id"; Code[20])
        {
            Caption = 'Job Id';
            Editable = false;
        }
        field(5; "New Job Id"; Code[20])
        {
            Caption = 'New Job Id';
            TableRelation = "HR Jobs"."Job ID";
        }
        field(6; "Salary Grade"; Integer)
        {
            Caption = 'Salary Grade';
            Editable = false;
        }
        field(7; "New Salary Grade"; Integer)
        {
            Caption = 'New Salary Grade';
            TableRelation = "Sal Grades"."Salary Grade";
        }
        field(8; Status; option)
        {
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
        }
        field(9; Sector; code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            trigger OnValidate()
            begin
                Clear("Global Dimension 3 Code");
                Clear("Global Dimension 2 Code");
                Clear(District);
                Clear(Division);               
            end;
        }
        field(10; District; code[20])
        {
            DataClassification = ToBeClassified;            
            TableRelation = Departments."Department Code" where("Sector Code" = field(Sector), level = const(District));

            trigger OnValidate()
            begin
                TestField(Sector);
                Clear(Division);
                Clear("Global Dimension 3 Code");                
                Clear("Global Dimension 2 Code");
                departmentsRec.Reset();
                departmentsRec.SetRange(departmentsRec."Department Code", "Global Dimension 2 Code");
                departmentsRec.SetRange(departmentsRec.level, departmentsRec.level::District);
                if departmentsRec.FindFirst() then begin

                    Sector := departmentsRec."Sector Code";
                end;               
            end;
        }
        field(11; "Global Dimension 2 Code"; Code[20])
        {            
            Caption = 'Department/District';            
            TableRelation = Departments."Department Code" where("Sector Code" = field(Sector), level = const(Department));
            trigger OnValidate()
            begin
                TestField(Sector);
                TestField(Sector);
                Clear(Division);
                Clear("Global Dimension 3 Code");
              
                Clear(District);
                departmentsRec.Reset();
                departmentsRec.SetRange(departmentsRec."Department Code", "Global Dimension 2 Code");
                departmentsRec.SetRange(departmentsRec.level, departmentsRec.level::Department);
                if departmentsRec.FindFirst() then begin

                end;
              
            end;
        }
        field(12; "Global Dimension 3 Code"; Code[20])
        {
            
            Caption = 'Division/Branch';            
            TableRelation = Branches."Division/Branch Code" where("Department/District Code" = field(District), level = const(Branch), "Sector Code" = field(Sector));

            trigger OnValidate()
            var

            begin
                TestField(Sector);
                TestField(District);
                //clear("Branch Grade");
                Clear("Global Dimension 2 Code");
                Clear(Division);
                branchesdivRec.Reset();
                branchesdivRec.SetRange(branchesdivRec."Department/District Code", District);
                branchesdivRec.SetRange(branchesdivRec.level, branchesdivRec.level::Branch);
                if branchesdivRec.FindFirst() then begin
                    branchgrade.Reset();
                    branchgrade.SetRange(branchgrade."Branch Code", "Global Dimension 3 Code");
                    if branchgrade.FindFirst() then begin
                       
                    end;
                end;      


            end;
        }
        field(13; Division; code[20])
        {
            //TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
            TableRelation = Branches."Division/Branch Code" where("Department/District Code" = field("Global Dimension 2 Code"), level = const(Division), "Sector Code" = field(Sector));
            trigger OnValidate()
            begin
                TestField("Global Dimension 2 Code");
                TestField(Sector);
                branchesdivRec.Reset();
                branchesdivRec.SetRange(branchesdivRec."Division/Branch Code", Division);
                branchesdivRec.SetRange(branchesdivRec.level, branchesdivRec.level::Division);
                if branchesdivRec.FindFirst() then begin
                    branchesdivRec.TestField("Sector Code");
                    branchesdivRec.TestField("Department/District Code");                    
                    Clear("Global Dimension 3 Code");
                    Clear(District);
                    Clear(branchgrade);                    
                end else if not branchesdivRec.Find() then begin
                    Error('Division does not exists on the organogram');

                end;                
            end;
        }  
        field(14; "Work Station"; Code[20])
        {
            TableRelation = Branches."Division/Branch Code" where(level = const(Branch));
            trigger OnValidate()
            begin                

            end;
        } 
         field(15; "New Sector"; code[20])
        {
             Caption='New Sector';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            trigger OnValidate()
            begin
                Clear("New Global Dimension 3 Code");
                Clear("New Global Dimension 2 Code");
                Clear("New District");
                Clear("New Division");               
            end;
        }
        field(16; "New District"; code[20])
        {
             caption='New District';
            DataClassification = ToBeClassified;            
            TableRelation = Departments."Department Code" where("Sector Code" = field("New Sector"), level = const(District));

            trigger OnValidate()
            begin
                TestField("New Sector");
                Clear("New Division");
                Clear("New Global Dimension 3 Code");                
                Clear("New Global Dimension 2 Code");
                departmentsRec.Reset();
                departmentsRec.SetRange(departmentsRec."Department Code", "New Global Dimension 2 Code");
                departmentsRec.SetRange(departmentsRec.level, departmentsRec.level::District);
                if departmentsRec.FindFirst() then begin

                    "New Sector" := departmentsRec."Sector Code";
                end;               
            end;
        }
        field(17; "New Global Dimension 2 Code"; Code[20])
        {            
            Caption = 'New Department';            
            TableRelation = Departments."Department Code" where("Sector Code" = field("New Sector"), level = const(Department));
            trigger OnValidate()
            begin
                TestField("New Sector");
                
                Clear("New Division");
                Clear("New Global Dimension 3 Code");
              
                Clear(District);
                departmentsRec.Reset();
                departmentsRec.SetRange(departmentsRec."Department Code", "New Global Dimension 2 Code");
                departmentsRec.SetRange(departmentsRec.level, departmentsRec.level::Department);
                if departmentsRec.FindFirst() then begin

                end;
              
            end;
        }
        field(18; "New Global Dimension 3 Code"; Code[20])
        {
            
            Caption = 'New Branch';            
            TableRelation = Branches."Division/Branch Code" where("Department/District Code" = field("New District"), level = const(Branch), "Sector Code" = field("New Sector"));

            trigger OnValidate()
            var

            begin
                TestField("New Sector");
                TestField("New District");                
                Clear("New Global Dimension 2 Code");
                Clear("New Division");
                branchesdivRec.Reset();
                branchesdivRec.SetRange(branchesdivRec."Department/District Code", "New District");
                branchesdivRec.SetRange(branchesdivRec.level, branchesdivRec.level::Branch);
                if branchesdivRec.FindFirst() then begin
                    branchgrade.Reset();
                    branchgrade.SetRange(branchgrade."Branch Code", "New Global Dimension 3 Code");
                    if branchgrade.FindFirst() then begin
                       
                    end;
                end;      


            end;
        }
        field(19; "New Division"; code[20])
        
        {
            Caption='New Division';
            //TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
            TableRelation = Branches."Division/Branch Code" where("Department/District Code" = field("New Global Dimension 2 Code"), level = const(Division), "Sector Code" = field("New Sector"));
            trigger OnValidate()
            begin
                TestField("New Global Dimension 2 Code");
                TestField("New Sector");
                branchesdivRec.Reset();
                branchesdivRec.SetRange(branchesdivRec."Division/Branch Code", "New Division");
                branchesdivRec.SetRange(branchesdivRec.level, branchesdivRec.level::Division);
                if branchesdivRec.FindFirst() then begin
                    branchesdivRec.TestField("Sector Code");
                    branchesdivRec.TestField("Department/District Code");                    
                    Clear("New Global Dimension 3 Code");
                    Clear("New District");
                    //Clear(branchgrade);                    
                end else if not branchesdivRec.Find() then begin
                    Error('Division does not exists on the organogram');

                end;                
            end;
        }  
        field(20; "New Work Station"; Code[20])
        {
             Caption='New Workstation';
            TableRelation = Branches."Division/Branch Code" where(level = const(Branch));
            trigger OnValidate()
            begin                

            end;
        } 


        field(30; "Is HOD"; Boolean)
        {
            Editable = false;
        }
        field(31; "Key Experience"; Text[150]) { }
        field(32; "Current Gross Pay"; Decimal) { }
        field(33; "Reason Description"; Text[150]) { }

        field(34; Comment; Text[200])
        {
            Editable = true;
        }

        field(35; type; Option)
        {
            OptionMembers = Promotion,Demotion,Transfer,Employment,"Acting Position","Temporary Position",Delegation;
            OptionCaption = 'Promotion,Demotion,Transfer,Employment,Acting Position,Temporary Position,Delegation';
        }

        field(50; "Created By"; code[50])
        {
            Editable = false;
        }
        field(51; "Date Created"; date) { Editable = false; }
        field(52; "Time Created"; Time) { Editable = false; }
        field(53; "No. Series"; Code[10])
        {
            Editable = false;
            TableRelation = "No. Series";
        }
        field(54; posted; Boolean)
        {
            Editable = true;

        }
        field(55; "Posted By"; code[50])
        {
            Editable = false;


        }
        field(56; "Date posted"; DateTime)
        {
            Editable = false;

        }

        field(57; "New Position Start Date"; Date)
        {
            Editable = true;

        }
        
        field(5004; "Is Now HOD"; Boolean)
        {
            Editable = true;
        }





    }
    keys
    {
        key(PK; Promtion_No, Employee_No)
        {
            Clustered = true;
        }
    }
    trigger oninsert()
    begin

        IF Promtion_No = '' THEN BEGIN
            HRSetup.Get;
            HRSetup.TestField(Promotion_No);
            Promtion_No := NoSeriesMgt.GetNextNo(HRSetup.Promotion_No, Today, true);
            //"No. Series" := '';

        END;
    end;

    var
        DimVal: Record "Dimension Value";
        hremp: Record "HR-Employee";
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
        salgrades: record "Sal Grades";
        hrpro: Record HR_Promotion;        
        branchgrade: Record "Branch Grading";
        distrctsdepartRec: Record Departments;
        branchesdivRec: Record Branches;

        departmentsRec: Record Departments;

        sectorsRec: Record Sectors;


        organogra: Record Organogram;
}
