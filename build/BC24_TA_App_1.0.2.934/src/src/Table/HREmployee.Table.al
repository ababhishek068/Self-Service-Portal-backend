Table 50746 "HR-Employee"
{
    Caption = 'HR Employees';
    DataCaptionFields = "No.", "Full Name", "Job Title";
    DrillDownPageID = "HR Employee List";
    LookupPageID = "HR Employee List";
    fields
    {
        field(1; "No."; Code[30])
        {
            trigger OnValidate()
            begin
                IF "No." = '' THEN BEGIN
                    HRSetup.Get;
                    HRSetup.TestField("Employee Nos.");
                    NoSeriesMgt.TestManual(HRSetup."Employee Nos.");
                    "No. Series" := '';

                END;
            end;

        }
        field(2; "First Name"; Text[80])
        {

            trigger OnValidate()
            begin

                "Full Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name"
            end;
        }
        field(3; "Middle Name"; Text[50])
        {

            trigger OnValidate()
            begin
                "Full Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name"
            end;
        }
        field(4; "Last Name"; Text[50])
        {

            trigger OnValidate()
            begin
                "Full Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name"
            end;
        }
        field(5; Initials; Text[15]) { }
        field(7; "Full Name"; Text[100]) { }
        field(8; "Postal Address"; Text[30]) { }
        field(9; "Residential Address"; Text[40]) { }
        field(10; City; Text[30])
        {
            Editable = false;
        }
        field(11; "Post Code"; Code[10])
        {
            TableRelation = "Post Code";
            ValidateTableRelation = false;

            trigger onvalidate()
            var
                PostCode: Record "Post Code";
            begin
                clear(City);
                clear("Postal Address");

                PostCode.SetRange(PostCode.Code, "Post Code");
                if PostCode.FindFirst() then begin
                    City := PostCode.City;
                    "Postal Address" := PostCode.City;
                end;
            end;
        }

        field(12; Region; Code[20])
        {
            Editable = true;
            TableRelation = Region.code;

            trigger OnValidate()
            var
                RegionRec: Record Region;
            begin
                TestField("Works in Desert");
                RegionRec.Reset();
                RegionRec.SetRange(Code, Region);
                if RegionRec.Find('-') then begin
                    "Region Name" := RegionRec.Description;
                end;
            end;
        }
        field(13; "Home Phone Number"; Text[30]) { }
        field(14; "Cellular Phone Number"; Text[30]) { }
        field(15; "Work Phone Number"; Text[30]) { }
        field(16; "Ext."; Text[7]) { }
        field(17; "E-Mail"; Text[80])
        {
            ExtendedDatatype = EMail;
        }
        field(19; Picture; Blob)
        {
            SubType = Bitmap;
        }
        field(21; "ID Number"; Text[30])
        {

        }
        field(22; "Union Code"; Code[10])
        {
            TableRelation = Union;
        }
        field(23; "UIF Number"; Text[30]) { }
        field(24; Gender; Option)
        {
            OptionMembers = " ",Male,Female;
        }
        field(25; "Country Code"; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(28; "Statistics Group Code"; Code[10])
        {
            TableRelation = "Employee Statistics Group";
        }
        field(31; Status; Option)
        {
            OptionMembers = New,"Pending Approval",Active,InActive;

            trigger OnValidate()
            begin

                "Status Change Date" := Today;
            end;
        }
        field(35; "Location/Division Code"; Code[20])
        {
            Caption = 'District';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(36; "Department Code"; Code[20])
        {

        }
        field(37; Office; Code[20])
        {
            Description = 'Dimension 2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          "Dimension Value Type" = const(Standard));
        }
        field(38; "Resource No."; Code[20])
        {
            TableRelation = Resource;
        }
        field(39; Comment; Boolean)
        {
            Editable = false;
        }
        field(40; "Last Date Modified"; Date)
        {
            Editable = false;
        }
        field(41; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(42; "Department Filter 1"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(43; "Office Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(47; "Employee No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "HR-Employee";
        }

        field(48; "Supervisor No."; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
                emps: record "HR-Employee";
                k: Boolean;
            begin
                k := Confirm('Do you wish to update the supervisor on all staff with the same previous supervisor?');
                if k = true then begin
                    emps.Reset;
                    emps.SetRange(emps."Supervisor No.", Rec."Supervisor No.");
                    if emps.FindSet then begin
                        repeat
                            emps."Supervisor No." := Rec."Supervisor No.";
                            emps.Modify;
                        until emps.next = 0;
                    end;

                end else if k = false then begin
                end;

            end;
        }
        field(49; "Fax Number"; Text[30]) { }
        field(50; "Company E-Mail"; Text[80]) { }
        field(51; Title; Option)
        {
            OptionMembers = " ",Mr,Mrs,Miss,Ms,"Dr."," Eng. ",Prof;
        }
        field(52; "Salespers./Purch. Code"; Code[10]) { }
        field(53; "No. Series"; Code[10])
        {
            Editable = false;
            TableRelation = "No. Series";
        }
        field(54; "Known As"; Text[30]) { }
        field(55; Position; Text[30]) { }

        field(56; "New Basic Pay"; Decimal) { }
        field(57; "Full / Part Time"; Option)
        {
            OptionMembers = " ","Full Time"," Part Time",Contract;
        }
        field(58; "Contract Type"; Code[20])
        {
            TableRelation = "HR Lookup Values".Code where(Type = filter("Contract Type"));
        }
        field(59; "Contract End Date"; Date)
        {
            //Editable = false;
        }
        field(60; "Notice Period"; Code[10]) { }
        field(61; "Union Member?"; Boolean) { }
        field(62; "Shift Worker?"; Boolean) { }
        field(63; "Contracted Hours"; Decimal) { }
        field(64; "Pay Period"; Option)
        {
            OptionMembers = Weekly,"2 Weekly","4 Weekly",Monthly," ";
        }
        field(65; "Pay Per Period"; Decimal) { }
        field(66; "Cost Code"; Code[20]) { }
        field(68; "Secondment Institution"; Text[30]) { }
        field(69; "UIF Contributor?"; Boolean) { }
        field(73; "Marital Status"; Option)
        {
            OptionMembers = " ",Single,Married,Separated,Divorced,"Widow(er)",Other;
        }
        field(74; "Ethnic Origin"; Option)
        {
            OptionMembers = African,Indian,White,Coloured;
        }
        field(75; "First Language (R/W/S)"; Code[10]) { }
        field(76; "Driving Licence"; Code[10]) { }
        field(77; "Vehicle Registration Number"; Code[10]) { }
        field(78; Disabled; Option)
        {
            Caption = 'Persons with Disability?';
            OptionMembers = No,Yes," ";

        }
        field(79; "Health Assesment?"; Boolean) { }
        field(80; "Health Assesment Date"; Date) { }
        field(81; "Date Of Birth"; Date)
        {
            trigger OnValidate()
            begin
                if (today - "Date Of Birth") <= 18 then Error('Invalid date of birth');
                IF "Date Of Birth" <> 0D then begin

                    IF Disabled = Disabled::No THEN "Retirement date" := CalcDate('60Y', "Date Of Birth");

                    IF Disabled = Disabled::Yes THEN "Retirement date" := CalcDate('65Y', "Date Of Birth");

                end else begin
                    Clear("Retirement date");
                end;
            end;

        }
        field(82; Age; Text[80]) { }
        field(84; "Length Of Service"; Text[80]) { }
        field(85; "End Of Probation Date"; Date) { }
        field(86; "Pension Scheme Join"; Date) { }
        field(87; "Time Pension Scheme"; Text[80]) { }
        field(88; "Medical Scheme Join"; Date) { }
        field(89; "Time Medical Scheme"; Text[80]) { }
        field(90; "Date Of Leaving"; Date) { }
        field(91; Paterson; Code[10]) { }
        field(92; Peromnes; Code[10]) { }
        field(93; Hay; Code[10]) { }
        field(94; Castellion; Code[10]) { }
        field(95; "Per Annum"; Decimal) { }
        field(96; "Allow Overtime"; Option)
        {
            OptionMembers = Yes,No," ";
        }
        field(97; "Medical Scheme No."; Text[30]) { }
        field(98; "Medical Scheme Head Member"; Text[60]) { }
        field(99; "Number Of Dependants"; Integer) { }
        field(100; "Medical Scheme Name"; Text[70]) { }
        field(101; "Amount Paid By Employee"; Decimal) { }
        field(102; "Amount Paid By Company"; Decimal) { }
        field(103; "Receiving Car Allowance ?"; Boolean) { }
        field(104; "Second Language (R/W/S)"; Code[10]) { }
        field(105; "Additional Language"; Code[10]) { }
        field(106; "Cell Phone Reimbursement?"; Boolean) { }
        field(107; "Amount Reimbursed"; Decimal) { }
        field(108; "UIF Country"; Code[10])
        {
            TableRelation = "Country/Region".Code;
        }
        field(109; "Direct/Indirect"; Option)
        {
            OptionMembers = Direct,Indirect;
        }
        field(110; "Primary Skills Category"; Option)
        {
            OptionMembers = Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(111; Level; Option)
        {
            OptionMembers = " ","Level 1","Level 2","Level 3","Level 4","Level 5","Level 6","Level 7";
        }
        field(112; "Termination Category"; Option)
        {
            OptionMembers = " ",Resignation,"Non-Renewal Of Contract",Dismissal,Retirement,Death,Other;

            trigger OnValidate()
            begin
            end;
        }
        field(113; "Job ID"; Code[30])
        {
            Description = 'To put description on Job title field';
            TableRelation = "HR Jobs"."Job ID";
            trigger OnValidate()
            var
                HRJobs: Record "HR Jobs";
                noofpost: Integer;
                noofoccupied: integer;
            BEgin
                Clear("Job Title");
                noofoccupied := 0;
                noofpost := 0;
                HRJobs.Reset();
                HRJobs.SetRange(HRJobs."Job ID", "Job ID");
                if HRJobs.FindFirst() then begin
                    hrjobs.CalcFields("Occupied Positions");
                    noofpost := hrjobs."No of Posts";
                    noofoccupied := HRJobs."Occupied Positions";
                    if ((noofoccupied + 1) > noofpost) then begin
                        Error('Out of budget');
                    end;
                    "Job Title" := hrjobs."Job Description";
                    HRJobs.Validate("No of Posts");
                end;


            end;

        }
        field(114; DateOfBirth; Date) { }
        field(115; DateEngaged; Text[8]) { }
        field(116; "Postal Address2"; Text[30]) { }
        field(117; "Postal Address3"; Text[20]) { }
        field(118; "Residential Address2"; Text[30]) { }
        field(119; "Residential Address3"; Text[20]) { }
        field(120; "Post Code2"; Code[20])
        {
            TableRelation = "Post Code";
            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.Reset();
                PostCode.SetRange(code, "Post Code2");
                if PostCode.FindFirst() then begin
                    City := PostCode.City;
                end;
            end;
        }
        field(121; Citizenship; Code[10])
        {
            TableRelation = "Country/Region".Code;
        }
        field(122; "Name Of Manager"; Text[45]) { }
        field(123; "User ID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
            trigger OnValidate()
            var
                employ: Record "HR-Employee";
                countsno: Integer;
            begin

                if rec."User ID" <> '' then begin
                    countsno := 0;
                    employ.Reset();
                    employ.SetRange(employ."User ID", Rec."User ID");
                    if employ.Find('-') then begin
                        repeat
                            countsno := countsno + 1;

                        until employ.next = 0;
                    end;
                    if countsno > 1 then
                        Error('Same userid cannot be allocated to more than 1 employee');

                end;
            end;
        }
        field(124; "Disabling Details"; Text[20]) { }
        field(125; "Disability Grade"; Text[20]) { }
        field(126; "Passport Number"; Text[10]) { }
        field(127; "2nd Skills Category"; Option)
        {
            OptionMembers = " ",Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(128; "3rd Skills Category"; Option)
        {
            OptionMembers = " ",Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(129; PensionJoin; Text[8]) { }
        field(130; DateLeaving; Text[30]) { }
        // field(131; Region; Code[20])
        // {
        //     TableRelation = "Dimension Value".Code where("Dimension Code" = const('REGION'));
        // }
        field(132; "Manager Emp No"; Code[30]) { }
        field(133; Temp; Text[20]) { }
        field(134; "Employee Qty"; Integer) { }
        field(135; "Employee Act. Qty"; Integer) { }
        field(136; "Employee Arc. Qty"; Integer) { }
        field(137; "Contract Location"; Text[20])
        {
            Description = 'Location where contract was closed';
        }
        field(138; "First Language Read"; Boolean) { }
        field(139; "First Language Write"; Boolean) { }
        field(140; "First Language Speak"; Boolean) { }
        field(141; "Second Language Read"; Boolean) { }
        field(142; "Second Language Write"; Boolean) { }
        field(143; "Second Language Speak"; Boolean) { }
        field(144; "Custom Grading"; Code[20]) { }
        field(145; "TIN No."; Code[20]) { }

        field(146; "Pension No."; Code[20]) { }
        field(147; "NHIF No."; Code[20]) { }
        field(148; "Cause of Inactivity Code"; Code[10])
        {
            Caption = 'Cause of Inactivity Code';
            TableRelation = "Cause of Inactivity";
        }
        field(149; "Grounds for Term. Code"; Code[10])
        {
            Caption = 'Grounds for Termination Code';
            TableRelation = "Grounds for Termination";
        }
        field(150; "Sacco Staff No"; Code[20]) { }
        field(151; "Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "PR Payroll Periods"."Date Opened";
        }
        field(152; "HELB No"; Text[10]) { }
        field(153; "Co-Operative No"; Text[20]) { }
        field(154; "Wedding Anniversary"; Date) { }
        field(156; "Competency Area"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(157; "Cost Center Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                          "Dimension Value Type" = const(Standard));
        }
        field(158; "Position To Succeed"; Code[20]) { }
        field(159; "Succesion Date"; Date) { }
        field(160; "Send Alert to"; Code[20]) { }
        field(161; Tribe; Code[20])
        {
            TableRelation = "Sub Tribe"."Sub Tribe Code";
        }
        field(162; Religion; Code[20])
        {
            TableRelation = "HR Lookup Values".Code where(Type = filter(Religion));
        }
        field(163; "Job Title"; Text[80]) { }
        field(164; "Post Office No"; Text[20]) { }
        field(165; "Posting Group"; Code[20])
        {
            //NotBlank = false;
            TableRelation = "PR Employee Posting Groups".Code;
            trigger OnValidate()
            begin

            end;

        }
        field(166; "Payroll Posting Group"; Code[20])
        {
            TableRelation = "PR Employee Posting Groups".Code;
            trigger OnValidate()
            begin
                "Posting Group" := "Payroll Posting Group";
            end;
        }
        field(167; "Served Notice Period"; Boolean) { }
        field(168; "Exit Interview Date"; Date) { }
        field(169; "Exit Interview Done by"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(170; "Allow Re-Employment In Future"; Boolean) { }
        field(171; "Medical Scheme Name #2"; Text[30]) { }
        field(172; "Resignation Date"; Date) { }
        field(173; "Suspension Date"; Date) { }
        field(174; "Demised Date"; Date) { }
        field(175; "Retirement date"; Date) { }
        field(176; "Retrenchment date"; Date) { }
        field(177; Campus; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('CAMPUS'));
        }
        field(178; Permanent; Boolean) { }
        field(179; "Library Category"; Option)
        {
            OptionMembers = "ADMIN STAFF","TEACHING STAFF",DIRECTORS;
        }
        field(180; Category; Code[20]) { }
        field(181; "Payroll Departments"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(186; "Annual Leave Code"; Code[50])
        {

            trigger OnValidate()
            begin
                // Validate("Annual Leave balance");
                // Validate("Leave Balance");
                // Validate("Total Leave Taken");
                // Validate("Carry forward");
            end;

            // TableRelation="Leave Types".code where(Annual=const(true));
        }
        field(188; "Salary Grade"; integer)
        {
            // TableRelation = "Sal Grades"."Salary Grade";
            trigger OnValidate()
            begin
                // Message('Yes' + '-->' + "No.");
            end;
        }
        field(189; "Company Type"; Option)
        {
            OptionCaption = 'Others,USAID';
            OptionMembers = Others,USAID;
        }


        field(190; "Main Bank"; Code[20])
        {
            TableRelation = "PR Bank Accounts"."Bank Code";
            Caption = 'Bank Code';

            trigger OnValidate()
            var
                PRBankAccounts: Record "PR Bank Accounts";
            begin
                clear("Bank Name");
                Clear("Branch Bank");
                Clear("Branch Name");
                //clear("Bank Account Number");

                PRBankAccounts.Reset();
                PRBankAccounts.SetRange("Bank Code", "Main Bank");
                if PRBankAccounts.FindFirst() then begin
                    "Bank Name" := uppercase(PRBankAccounts."Bank Name");
                end;
            end;
        }
        field(191; "Branch Bank"; Code[20])
        {
            TableRelation = "PR Bank Branches"."Branch Code" where("Bank Code" = field("Main Bank"));
            Caption = 'Branch Code';

            trigger OnValidate()
            var
                PRBankBranches: Record "PR Bank Branches";
            begin
                Clear("Branch Name");
                //clear("Bank Account Number");

                PRBankBranches.Reset();
                PRBankBranches.SetRange("Bank Code", "Main Bank");
                PRBankBranches.SetRange("Branch Code", "Branch Bank");
                if PRBankBranches.find('-') then begin
                    "Branch Name" := uppercase(PRBankBranches."Branch Name");
                end;
            end;
        }
        field(192; "Lock Bank Details"; Boolean) { }
        field(193; "Bank Account Number"; Code[50]) { }
        field(195; "Payroll Code"; Code[20]) { }
        field(196; "Holiday Days Entitlement"; Decimal) { }
        field(197; "Holiday Days Used"; Decimal) { }
        field(198; "Payment Mode"; Option)
        {
            OptionMembers = "Bank","Sacco";
        }
        field(199; "Hourly Rate"; Decimal) { }
        field(200; "Daily Rate"; Decimal) { }
        field(201; "Pays NHIF"; Boolean) { }
        field(202; "Pays Pension"; Boolean) { }
        field(203; "Pays PAYE"; Boolean) { }
        field(204; "Cost Share?"; Boolean)
        {
            trigger OnValidate()
            begin
                TestField("Cost Share Outstanding Balance");
                TestField("Cost Share Start Date");
            end;
        }
        field(205; "Branch Grade"; Integer)
        {
            Editable = true;
            TableRelation = "Branch Grading"."Branch Grade";
            trigger OnValidate()
            var

            begin
                branchgrade.Reset();
                branchgrade.SetRange(branchgrade."Branch Code", "Global Dimension 2 Code");
                branchgrade.SetRange(branchgrade."Branch Grade", "Branch Grade");
                if branchgrade.Find('-') then begin
                    if branchgrade.EndDate < Today then begin
                        Error('This branch grade is expired');
                    end;


                end;
            end;
        }
        field(250; "Cost Share Start Date"; Date) { }
        field(251; "Cost Share Outstanding Balance"; Decimal)
        {
            trigger OnValidate()
            begin
                Validate("CostShare Contributions");
            end;
        }
        field(252; "CostShare Contributions"; Decimal)
        {
            CalcFormula = sum("PR Period Transactions".Amount where("Employee Code" = field("No."), "Transaction Code" = filter('COSTSHARE'), "Period Closed" = filter(true)));
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;
            Editable = false;

            trigger OnValidate()
            begin
                //TestField("Period Filter");
                TestField("Cost Share Outstanding Balance");
                CalcFields("CostShare Contributions");
                "CostShare Balance" := "Cost Share Outstanding Balance" - "CostShare Contributions";
            end;
            //COSTSHARE
        }
        field(253; "CostShare Balance"; Decimal)
        {
            Editable = false;

        }
        field(254; "Cost Share End Date"; Date)
        {
            Editable = false;
        }
        field(255; "Guarantee Start Date"; Date)
        {
            Editable = true;
        }
        field(256; "Guarantee Outstanding Balance"; Decimal)
        {
            CalcFormula = sum("Loan Guarantee Lines"."Amount to Pay" where("Guarantor Code" = field("No."), Closed = const(false)));
            //CalcFormula = sum("Loan Guarantee Lines".Amount where("Employee Code" = field("No."), "Transaction Code" = filter('GUARANTEE'), "Period Closed" = filter(true)));
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;
            Editable = false;
            trigger OnValidate()
            begin
                Validate("Guarantee Contributions");
            end;
        }
        field(257; "Guarantee Contributions"; Decimal)
        {
            CalcFormula = sum("PR Period Transactions".Amount where("Employee Code" = field("No."), "Transaction Code" = filter('GA'), "Period Closed" = filter(true)));
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;
            Editable = false;

            trigger OnValidate()
            begin
                //TestField("Period Filter");
                TestField("Guarantee Outstanding Balance");
                CalcFields("Guarantee Contributions");
                "Guarantee Balance" := "Guarantee Outstanding Balance" - "Guarantee Contributions";
            end;
            //COSTSHARE
        }
        field(258; "Guarantee Balance"; Decimal)
        {
            Editable = false;

        }
        field(259; "Guarantee Share End Date"; Date)
        {
            Editable = false;
        }
        field(260; "Hiring Guarantee?"; Boolean)
        {
            Editable = false;
            trigger OnValidate()
            begin
                TestField("Hiring Guarantor");

            end;
        }
        field(261; "Hiring Guarantor"; text[50])
        {
            trigger OnValidate()
            begin
                if "Hiring Guarantor" <> '' then begin
                    "Hiring Guarantee?" := true;

                end else if "Hiring Guarantor" = '' then begin
                    "Hiring Guarantee?" := false;

                end;

            end;
        }

        field(300; "Social Security No."; Code[20]) { }
        field(301; "Pension House"; Code[20])
        {
            // TableRelation = "pr Institutional Membership"."Institution No" where ("Group No"=const(PENSION));
        }
        field(302; "Salary Notch/Step"; Code[20]) { }
        field(303; "Status Change Date"; Date) { }
        field(304; "Previous Month Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(305; "Current Month Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(306; "Prev. Basic Pay"; Decimal) { }
        field(307; "Curr. Basic Pay"; Decimal) { }
        field(308; "Prev. Gross Pay"; Decimal) { }
        field(309; "Curr. Gross Pay"; Decimal) { }
        field(310; "Gross Income Variation"; Decimal) { }
        field(311; "Basic Pay 2"; Decimal)
        {
            Editable = false;
        }
        field(312; "Net Pay"; Decimal) { }
        field(313; "Transaction Amount"; Decimal) { }
        field(314; "Transaction Code Filter"; Text[30]) { }
        field(317; "Account Type"; Option)
        {
            OptionCaption = ' ,Savings,Current';
            OptionMembers = " ",Savings,Current;
        }
        field(318; "Location/Division Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('LOC/DIV'));
        }
        field(319; "Department Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DEPARTMENT'));
        }
        field(320; "Cost Centre Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('COSTCENTRE'));
        }
        field(323; "Payroll Type"; Option)
        {
            Description = 'General,Consultants,Seconded Staff';
            OptionCaption = 'General,Consultants,Seconded Staff';
            OptionMembers = General,Consultants,"Seconded Staff";
        }
        field(324; "Employee Classification"; Code[20])
        {
            Description = 'Service';
        }
        field(328; "Department Name"; Text[30]) { }
        field(329; "Temporary Job ID"; Code[30])
        {
            Description = 'To put description on Job title field';
            TableRelation = "HR Jobs"."Job ID";
            trigger OnValidate()
            var
                HRJobs: Record "HR Jobs";
            BEgin
                Clear("Temporary Job");
                if HRJobs.Get("Temporary Job ID") then "Temporary Job" := hrjobs."Job Description";
            end;

        }
        field(330; "Acting Job ID"; Code[30])
        {
            Description = 'To put description on Acting Job title field';
            TableRelation = "HR Job Grades".Code;
            trigger OnValidate()
            var
                HRJobs: Record "HR Jobs";
            BEgin
                Clear("Acting job");
                if HRJobs.Get("Acting Job ID") then "Acting job" := hrjobs."Job Description";
            end;

        }
        field(331; "Temporary Job"; text[50])
        {
            Editable = false;

        }
        field(332; "Acting job"; text[50])
        {
            Editable = false;
        }
        field(333; "Acting job Expiry Date"; date)
        {
            Editable = true;
            trigger OnValidate()
            var
                NoOfMonths: Integer;
                NoOfYears: Integer;
                noofm: Integer;
                prperiod: Record "PR Payroll Periods";
                currperiod: date;
            begin
                prperiod.Reset();
                prperiod.SetRange(prperiod.Closed, false);
                if prperiod.FindFirst() then begin
                    currperiod := prperiod."Date Opened";
                end;


                TestField("Acting job Start Date");
                if "Acting job Expiry Date" <> 0D then begin
                    if "Acting job Expiry Date" <= "Acting job Start Date" then
                        Error('Expiry date must be greater than start date');
                end;
                if ("Acting job Expiry Date" < Today) then begin
                    "Acting Position?" := false;
                    NoOfYears := DATE2DMY("Acting job Expiry Date", 3) - DATE2DMY("Acting job Start Date", 3);
                    NoOfMonths := DATE2DMY("Acting job Expiry Date", 2) - DATE2DMY("Acting job Start Date", 2);
                    noofm := (12 * NoOfYears + NoOfMonths);
                    "Acting Position Months" := noofm;
                    "No of acting Days" := Today - "Acting job Start Date";

                end else begin
                    "Acting Position?" := true;
                end;
                if "Acting Position?" = true then begin
                    Clear(noofm);
                    Clear(NoOfMonths);
                    Clear(NoOfYears);
                    if (rec."Acting job Expiry Date" = 0D) or (rec."Acting job Expiry Date" > Today) then begin
                        NoOfYears := DATE2DMY(Today, 3) - DATE2DMY("Acting job Start Date", 3);
                        NoOfMonths := DATE2DMY(Today, 2) - DATE2DMY("Acting job Start Date", 2);
                        noofm := (12 * NoOfYears + NoOfMonths);
                        "Acting Position Months" := noofm;
                        "No of acting Days" := today - "Acting job Start Date";
                    end else if (rec."Acting job Expiry Date" <> 0D) or (rec."Acting job Expiry Date" < Today) then begin
                        NoOfYears := DATE2DMY("Acting job Expiry Date", 3) - DATE2DMY("Acting job Start Date", 3);
                        NoOfMonths := DATE2DMY("Acting job Expiry Date", 2) - DATE2DMY("Acting job Start Date", 2);
                        noofm := (12 * NoOfYears + NoOfMonths);
                        "Acting Position Months" := noofm;
                        "No of acting Days" := "Acting job Expiry Date" - "Acting job Start Date";
                    end;


                    //Message(Format(noofm)+'  Months');
                end;
            end;
        }
        field(334; "Temporary job Expiry Date"; date)
        {
            Editable = true;
        }
        field(335; "Acting Position Months"; Integer)
        {
            Editable = false;
        }
        field(336; "Acting Basic Pay"; Decimal) { }
        field(337; "Acting Taxable Allowances"; Decimal) { }
        field(338; "Acting Non-Taxable All"; Decimal) { }
        field(339; "Acting Job Grade";Integer)
        {
            Caption = 'Acting Salary Grade';
            TableRelation = "Sal Grades"."Salary Grade" where("Job Group" = field("Acting Job ID"));
            trigger OnValidate()
            begin
                TestField("Acting Job ID");
                TestField("Work Station");
            end;
        }
        field(340; "No of acting Days"; Integer) { }
        field(341; "Arrears Days"; Integer) { }
        field(342; "Acting Arrears Days"; Integer) { }
        field(343; "Promoted"; Boolean) { Editable = false; }
        field(344; "Demoted"; Boolean) { Editable = false; }
        field(345; "Transfered"; Boolean) { editable = false; }
        field(346; "Demotion/Transfer/Promotion Date"; date) { editable = false; }
        field(347; "Reason for tran/demo/pro"; text[150])
        {
            Editable = false;
            caption = 'Reason for Promotion/Demotion/Transfer';
        }
        field(348; "Earned Leave Days"; Decimal) { Editable = false; }
        field(349; "Leave in Birr"; Decimal)
        {
            Editable = false;
        }
        field(350; "No of Worked Days"; Integer) { Editable = false; }
        field(780; "PWD No"; Code[50])
        {
            Caption = 'Persons with Disability No.';

        }

        field(781; "PWD Start Date"; Date)
        {
            Caption = 'PWD Start Date';
            trigger OnValidate()
            begin

            end;
        }


        field(782; "PWD Expiry Date"; Date) { }

        field(783; "PWD Duration"; DateFormula)
        {
            trigger OnValidate()
            begin

                "PWD Expiry Date" := CalcDate("PWD Duration", "PWD Start Date");
                "PWD Notification Date" := CalcDate('-3M', "PWD Expiry Date");
            end;

        }


        field(785; "PWD Notification Date"; date) { }

        field(786; "Employee-Type"; Option)
        {
            OptionMembers = "Internal","Outsourced";
            OptionCaption = 'Internal,Outsourced';
            Editable = false;
        }

        field(787; "Acting job Start Date"; date)
        {
            Editable = true;
            trigger OnValidate()
            begin
                TestField("Acting Job ID");
            end;
        }
        field(788; "Acting Position?"; Boolean)
        {
            Editable = false;
        }



        field(888; "Medical Scheme Member No."; Code[30])
        {
            TableRelation = "HR Medical Scheme Members"."Member No";
            trigger OnValidate()
            var
                HRMedSchm: Record "HR Medical Scheme Members";
            begin
                HRMedSchm.Reset();
                HRMedSchm.SetRange("Scheme No", "Medical Scheme Member No.");
                if HRMedSchm.Find('-') then begin
                    "Medical Scheme Join Date" := HRMedSchm."Scheme Join Date";
                end;
            end;
        }
        field(800; "Loan Guarantee?"; Boolean)
        {
            Editable = false;

        }
        field(801; "Clearance Form?"; boolean) { }
        field(802; "Emergency Contact Name"; text[50]) { }
        field(803; "Emergency Contact Phone No"; code[11]) { }
        field(804; "Emergency Contact Email"; text[50]) { }
        field(805; Division; code[20])
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
                    "Division Name" := branchesdivRec."Division/Branch Name";
                    Clear("Global Dimension 3 Code");
                    //Clear(District);
                    Clear(branchgrade);
                    // Sector := branchesdivRec."Sector Code";
                    // "Global Dimension 2 Code" := branchesdivRec."Department/District Code";

                end else if not branchesdivRec.Find() then begin
                    Error('Division does not exists on the organogram');


                end;




                // DimVal.Reset;
                // DimVal.SetRange(DimVal.Code, "Global Dimension 5 Code");
                // if DimVal.Find('-') then
                //     "Global Dimension 5 Name" := DimVal.Name;
            end;
        }
        field(806; Sector; code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                Clear("Global Dimension 3 Code");
                Clear("Global Dimension 2 Code");
               // Clear(District);
                Clear(Division);
                Clear(branchgrade);
                DimVal.Reset();
                DimVal.SetRange(DimVal.code, Sector);
                dimval.SetRange(dimval."Global Dimension No.", 1);
                if dimval.FindFirst() then begin
                    "Sector Name" := DimVal.Name;

                end;
            end;
        }
        field(807; "Token Expired?"; Boolean)
        {

        }
        field(808; "Changed Password"; Boolean)
        {

        }
        field(809; "Reset Token"; Text[20])
        {

        }
        field(900; "Sector Name"; text[50]) { }


        field(2004; "Total Leave Taken"; Decimal)
        {
            CalcFormula = sum("HR Leave Allocation"."No. of Days" where("No." = field("No."),
                                                                             //"Posting Date" = field("Date Filter"),
                                                                             "Leave Type" = filter('ANNUAL'),
                                                                             "Posting Type" = filter('Normal'),
                                                                             Closed = const(false),
                                                                             "Calendar Code" = field("Current HR Calender"),
                                                                             "Entry Type" = const("Negative Adjustment")));
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;
        }
        field(2006; "Total (Leave Days)"; Decimal)
        {
            CalcFormula = sum("HR Leave Allocation"."No. of days" where("No." = field("No."),
                                                                             // "Posting Date" = field("Date Filter"),
                                                                             "Leave Type" = filter('ANNUAL'),
                                                                             "Posting Type" = filter('Normal'),
                                                                             Closed = const(false),
                                                                             "Calendar Code" = field("Current HR Calender"),
                                                                             "Entry Type" = const("Positive Adjustment")));
            Caption = 'Total Leav Allocated';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(2007; "Cash - Leave Earned"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(2008; "Reimbursed Leave Days"; Decimal)
        {
            CalcFormula = sum("HR Leave Allocation"."No. of days" where("No." = field("No."),
                                                                             //"Posting Date" = field("Date Filter"),
                                                                             "Leave Type" = filter('ANNUAL'),
                                                                             "Posting Type" = filter('Reimbursement'),
                                                                             Closed = const(false),
                                                                             "Calendar Code" = field("Current HR Calender"),
                                                                             "Entry Type" = filter("Positive Adjustment")));
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;

            trigger OnValidate()
            begin

                Validate("Annual Leave balance");
            end;
        }
        field(2009; "Cash per Leave Day"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }

        field(2010; "Customer No"; Code[30])
        {
            TableRelation = Customer."No." where("Customer Posting Group" = filter('IMPREST' | 'SDEBTORS'));
            editable = true;


        }
        field(2011; "Customer Name"; Code[30])
        {
            editable = false;
        }


        field(2023; "Annual Leave balance"; Decimal)
        {
            CalcFormula = sum("HR Leave Ledger"."No. of days" where("Employee No" = field("No."),
                                                                             Closed = filter(false),
                                                                             "Leave Type" = filter('ANNUAL'),
                                                                             "Leave Period" = field("Period Year Filter"),

                                                                             Closed = const(false),
                                                                             "Transaction Date" = field("Date Filter")));
            FieldClass = FlowField;
        }

        field(2024; "End of Contract Date"; Date) { }
        field(2040; "Leave Period Filter"; Code[20]) { }

        field(2041; "Contract Duration"; DateFormula) { }
        field(3899; "Mutliple Bank A/Cs"; Boolean) { }
        field(3900; "No. Of Bank A/Cs"; Integer) { }
        field(3940; "Exam Leave Days"; Decimal)
        {
            CalcFormula = sum("HR Leave Ledger"."No. of days" where("Employee No" = field("No."),
                                                                             Closed = filter(false),
                                                                             "Leave Period" = field("Period Year Filter"),
                                                                             "Leave Type" = filter('EXAM')));
            FieldClass = FlowField;
        }
        field(3971; "Annual Leave Account"; Decimal)
        {
            CalcFormula = sum("HR Leave Ledger"."No. of days" where("Employee No" = field("No."),
                                                                             Closed = filter(false),
                                                                             "Leave Type" = filter('ANNUAL'),
                                                                             "Leave Period" = field("Period Year Filter"),
                                                                             "Transaction Date" = field("Date Filter")));

            FieldClass = FlowField;
        }
        field(3972; "Compassionate Leave Acc."; Decimal)
        {
            CalcFormula = sum("HR Leave Ledger"."No. of days" where("Employee No" = field("No."),
                                                                             Closed = filter(false),
                                                                             "Leave Type" = filter('COMP'),
                                                                             "Leave Period" = field("Period Year Filter"),
                                                                             "Transaction Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(3973; "Maternity Leave Acc."; Decimal)
        {

            CalcFormula = sum("HR Leave Ledger"."No. of days" where("Employee No" = field("No."),
                                                                             Closed = filter(false),
                                                                             "Leave Type" = filter('MATERNITY'),
                                                                             "Leave Period" = field("Period Year Filter"),
                                                                             "Transaction Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(3974; "Paternity Leave Acc."; Decimal)
        {
            CalcFormula = sum("HR Leave Ledger"."No. of days" where("Employee No" = field("No."),
                                                                             Closed = filter(false),
                                                                             "Leave Type" = filter('PATERNITY'),
                                                                             "Transaction Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(3975; "Emergency Leave"; Decimal)
        {
            CalcFormula = sum("HR Leave Ledger"."No. of days" where("Employee No" = field("No."),
                                                                             Closed = filter(false),
                                                                             "Leave Type" = filter('EMERGENCY'),
                                                                             "Transaction Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(3976; "Study Leave Acc"; Decimal)
        {
            CalcFormula = sum("HR Leave Ledger"."No. of days" where("Employee No" = field("No."),
                                                                             Closed = filter(false),
                                                                             "Leave Type" = filter('STUDY'),
                                                                             "Transaction Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(3977; "Appraisal Method"; Option)
        {
            OptionCaption = ' ,Normal Appraisal,360 Appraisal';
            OptionMembers = " ","Normal Appraisal","360 Appraisal";
        }
        field(3988; "Leave Type"; Code[20])
        {
            TableRelation = "Tender Line Specification".Code;
        }
        field(3989; "Employee Type"; Option)
        {
            OptionMembers = Primary,Seconded;

            trigger OnValidate()

            begin
                if "Employee Type" = "Employee Type"::Seconded then "Employee Contract Type" := "Employee Contract Type"::Seconded;
            end;
        }
        field(3990; "Annual Contract"; Decimal)
        {
            CalcFormula = sum("HR Leave Ledger"."No. of days" where("Employee No" = field("No."),
                                                                             "Leave Type" = filter('CONANNUAL')));
            FieldClass = FlowField;
        }
        field(50099; "Employees Type"; Option)
        {
            fieldclass = flowfield;
            OptionCaption = ' ,Permanent,Casual,Part Time,Interns,Contract,UnPaidLeave,Seconded';
            OptionMembers = " ",Permanent,Casual,"Part Time",Interns,Contract,UnPaidLeave,Seconded;
            CalcFormula = lookup("HR Lookup Values"."Employee Type" where(Code = field("Contract Type"), Type = filter("Contract Type")));
        }
        field(50100; "Guarantor Phone No"; Text[20]) { }
        field(50101; "Guarantor Work Place"; text[50]) { }
        field(50102; "Guarantor E-mail"; text[50]) { }
        field(50161; "Sub Tribe"; Code[20])
        {
            TableRelation = "Sub Tribe"."Sub Tribe Code";
        }
        field(50396; "Age(Years)"; Integer) { }
        field(50397; "Disregard Directorate"; Boolean) { }
        field(50398; "Is HOD"; Boolean) { }
        field(50399; "Lecturer"; Boolean) { }
        field(50400; "Lecturer Category"; code[20]) { }
        field(50401; "Part Time"; Boolean) { }
        field(50402; "Password"; text[100]) { }
        field(50403; "Reason for Changing Designation"; text[100])
        {
            Caption = 'Reason for Change of Designation';
        }

        field(50404; "Current Job ID"; Code[20])
        {

            TableRelation = "HR Jobs"."Job ID";
            trigger OnValidate()
            var
                HRJobs: Record "HR Jobs";
            BEgin
                Clear("Current Job Title");
                if HRJobs.Get("Job ID") then "Current Job Title" := hrjobs."Job Description";
            end;
        }

        field(50405; "Current Job Title"; Text[50])
        {
            Editable = false;
        }

        field(50406; "Salary Incremental Month"; Option)
        {

            OptionMembers = ,January,February,March,April,May,June,July,August,September,October,November,December;

        }

        field(50407; "Employement Type"; Code[20])
        {
            TableRelation = "HR Lookup Values".Code where(Type = filter("Contract Type"));
        }


        field(50408; "Secondment Type"; Option)
        {
            OptionMembers = " ",Incoming,Outgoing;
        }
        field(50409; "Pay Mode Committed"; Boolean) { }
        field(50410; "Global Dimension 2 Code"; Code[20])
        {
            //CaptionClass = 'branch';
            Caption = 'Department';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            //TableRelation = Departments."Department Code" where("Sector Code" = field(Sector), level = const(Department));
            trigger OnValidate()
            begin
                // TestField(Sector);
                // TestField(Sector);
                // Clear(Division);
                // Clear("Global Dimension 3 Code");
                // Clear("Branch Grade");
                // Clear(District);
                // departmentsRec.Reset();
                // departmentsRec.SetRange(departmentsRec."Department Code", "Global Dimension 2 Code");
                // departmentsRec.SetRange(departmentsRec.level, departmentsRec.level::Department);
                // departmentsRec.SetRange(departmentsRec."Sector Code", Sector);
                // if departmentsRec.FindFirst() then begin
                //     "Department Name" := departmentsRec."Department Name";


                //     // TestField(Sector);
                //     // Clear("Branch Grade");
                //     //Sector := departmentsRec."Sector Code";
                // end;

                // DimVal.Reset;
                // DimVal.SetRange(DimVal.Code, "Global Dimension 2 Code");
                // if DimVal.Find('-') then
                //     "Global Dimension 2 Name" := DimVal.Name;

                // branchgrade.Reset;
                // branchgrade.SetRange(branchgrade."Branch Code", "Global Dimension 2 Code");
                // if branchgrade.find('-') then begin
                //     repeat
                //         if branchgrade.EndDate >= Today then begin
                //             "Branch Grade" := branchgrade."Branch Grade";
                //         end;


                //     until branchgrade.Next = 0;

                // end;
                // branchesRec.Reset();
                // branchesRec.SetRange(branchesRec."Branch Code", "Global Dimension 2 Code");
                // if branchesRec.FindFirst() then begin
                //     District := branchesRec."District Code";
                // end;
            end;
        }
        field(50411; "Global Dimension 3 Name"; Text[55])
        {
            Editable = false;
        }
        field(50412; "Procurement Officer"; Boolean) { }
        field(50413; "ICT Officer"; Boolean) { }
        field(50414; "Employee Types"; Option)
        {

            OptionMembers = Employee,Casual,Intern,Attachee;
            OptionCaption = 'Employee,Casual,Intern,Attachee';

        }

        field(50415; "IFMIS No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50416; Pointer; Code[30]) { }
        field(50417; "On Suspension"; Boolean) { }
        field(50418; "On Interdiction"; Boolean) { }
        field(51399; "On Probation"; Boolean) { }

        field(51700; "Is Researcher"; Boolean) { }

        field(51701; "Days to Probation Date"; DateFormula) { }
        field(54399; "Investigating Officer"; Boolean) { }
        field(60057; Image; Media)
        {
            DataClassification = ToBeClassified;
        }
        field(60058; "Business Unit"; code[20])
        {
            DataClassification = ToBeClassified;

            //TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            //TableRelation = Departments."Department Code" where("Sector Code" = field(Sector), level = const(District));

            trigger OnValidate()
            begin
                // TestField(Sector);
                // Clear(Division);
                // Clear("Global Dimension 3 Code");
                // Clear("Branch Grade");
                // Clear("Global Dimension 2 Code");
                // departmentsRec.Reset();
                // departmentsRec.SetRange(departmentsRec."Department Code", District);
                // departmentsRec.SetRange(departmentsRec.level, departmentsRec.level::District);
                // departmentsRec.SetRange(departmentsRec."Sector Code", Sector);
                // if departmentsRec.FindFirst() then begin


                //     //TestField(Sector);
                //     "District Name" := departmentsRec."Department Name";

                //     Sector := departmentsRec."Sector Code";
                // end;


                // DimVal.Reset;
                // DimVal.SetRange(DimVal.Code, "Global Dimension 2 Code");
                // if DimVal.Find('-') then
                //     "Global Dimension 2 Name" := DimVal.Name;
            end;
        }
        field(60059; "District Name"; text[50])
        {
            DataClassification = ToBeClassified;
            editable = false;
        }
        field(60060; "Works in-out Office"; Option)
        {
            OptionMembers = "","In Office","Out of Office";
        }
        field(60061; "Allocate Transport Allowance?"; Boolean)
        {
            trigger OnValidate()
            var
                confirmation: Boolean;
                confimation2: boolean;
                allocateinternal: Boolean;
                allocateexternal: Boolean;
            begin
                allocateexternal := false;
                allocateinternal := false;
                if "Works in-out Office" = "Works in-out Office"::"In Office" then begin
                    confirmation := Confirm('Are you sure you want to allocate Transport Allowance?');
                    if confirmation = true then begin
                        allocateinternal := true;
                        allocateexternal := false;
                        allcoatetransportallowance(Rec."No.", allocateinternal, allocateexternal);
                        //Message('Successful, close card and re-open to see allowances');

                    end else begin

                    end;


                end else if "Works in-out Office" = "Works in-out Office"::"Out of Office" then begin
                    confirmation := Confirm('Are you sure you want to allocate Transport Allowance?');
                    if confirmation = true then begin
                        allocateinternal := false;
                        allocateexternal := true;
                        allcoatetransportallowance(Rec."No.", allocateinternal, allocateexternal);
                        //Message('Successful, close card and re-open to see allowances');
                    end else begin

                    end

                end else begin
                    Error('You must select if the employee works in or out of office');
                end;
            end;
        }
        field(60062; "Joined Social Club?"; Boolean) { Editable = false; }
        field(60063; "Left social Club?"; Boolean) { }
        field(60064; "Date of Joining Social Club"; date)
        {
            trigger OnValidate()
            begin
                TestField("Date Of Joining the Company");
                if "Date of Joining Social Club" >= "Date of Joining Social Club" then begin
                    "Joined Social Club?" := true;
                end else begin
                    Error('Date of Joining scheme must be equal or greater than date of joining company');
                end;
            end;
        }
        field(60065; "Paid social Club"; Boolean) { }
        //Social Club
        field(3900396; "Manager No."; Code[20]) { }
        field(3900397; "Current HR Calender"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("HR Leave Calendar".Code where(Current = filter(true)));
        }
        field(39003900; "Global Dimension 3 Code"; Code[20])
        {
            //CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));

            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "Global Dimension 3 Code");
                if DimVal.Find('-') then
                    "Global Dimension 3 Name" := DimVal.Name;
            end;
        }
        field(39003901; "Global Dimension 1 Code"; Code[20])
        {
            //CaptionClass = '1,1,3';
            Caption = 'Division';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            //TableRelation = Branches."Division/Branch Code" where("Department/District Code" = field(District), level = const(Branch), "Sector Code" = field(Sector));

            trigger OnValidate()
            var

            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                if DimVal.Find('-') then
                    "Global Dimension 1 Name" := DimVal.Name;
                "Division Name" := DimVal.Name;
                // TestField(Sector);
                // TestField(District);
                // clear("Branch Grade");
                // Clear("Global Dimension 2 Code");
                // Clear(Division);
                // branchesdivRec.Reset();
                // branchesdivRec.SetRange(branchesdivRec."Department/District Code", District);
                // branchesdivRec.SetRange(branchesdivRec.level, branchesdivRec.level::Branch);
                // branchesdivRec.SetRange(branchesdivRec."Sector Code", Sector);
                // if branchesdivRec.FindFirst() then begin
                //     "Branch- Name" := branchesdivRec."Division/Branch Name";
                //     //District := branchesdivRec."Department/District Code";
                //     //Sector := branchesdivRec."Sector Code";
                //     branchgrade.Reset();
                //     branchgrade.SetRange(branchgrade."Branch Code", "Global Dimension 3 Code");
                //     if branchgrade.FindFirst() then begin

                //         "Branch Grade" := branchgrade."Branch Grade";
                //     end;
                // end;
                // if Grade <> '' then begin
                //     rec.Validate(Grade);
                // end


                // DimVal.Reset;
                // DimVal.SetRange(DimVal.Code, "Global Dimension 3 Code");
                // if DimVal.Find('-') then begin
                //     "Global Dimension 3 Name" := DimVal.Name;

                // end;

                // departmentsRec.Reset();
                // departmentsRec.SetRange(departmentsRec."Department Code", "Global Dimension 3 Code");
                // if departmentsRec.FindFirst() then begin
                //     if departmentsRec."Branch Code" = '' then
                //         Error('Please update branch on the organogram');
                //     branchesRec.Reset();
                //     branchesRec.SetRange(branchesRec."Branch Code", departmentsRec."Branch Code");
                //     if branchesRec.FindFirst() then begin
                //         // "Global Dimension 1 Code":=branchesRec."District Code";
                //         "Global Dimension 2 Code" := branchesRec."Branch Code";
                //         Validate("Global Dimension 2 Code");
                //     end;

                // end;


            end;
        }
        field(39003902; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center BR".Code;
        }
        field(39003903; HR; Boolean) { }
        field(39003904; "Date Of Joining the Company"; Date)
        {

            trigger OnValidate()
            var
                HRSetup: Record "HR Setup";
            begin

                TestField("Job ID");
                TestField(Grade);
                //Felix-enable later
                // TestField("Global Dimension 1 Code");
                // TestField("Global Dimension 2 Code");
                // TestField(Sector);
                // TestField(District);
                // TestField(Division);
                // TestField("Department Code");
                TestField("Job ID");

                if Grade >= 10 then begin
                    "End Of Probation Date" := "Date Of Joining the Company" + 90;
                    if "End Of Probation Date" >= Today then begin

                        "On Probation" := true;
                    end else begin
                        "On Probation" := false;
                    end;

                end else if Grade < 10 then begin
                    "End Of Probation Date" := "Date Of Joining the Company" + 60;
                    if "End Of Probation Date" >= Today then begin

                        "On Probation" := true;
                    end else begin
                        "On Probation" := false;
                    end;

                end;
                HRSetup.get;
                if "Date Of Joining the Company" <> 0D then if "Date Of Joining the Company" > Today then Error(Txt003);
                "Date of First Appointment" := "Date Of Leaving the Company";
                calcannualleave(Rec);//felix 1
                PostPromotion(Rec);



            end;
        }
        field(39003905; "Date Of Leaving the Company"; Date)
        {

            trigger OnValidate()
            begin

                if "Date Of Leaving" <> 0D then begin
                    if "Date Of Joining the Company" <> 0D then begin
                        if "Date Of Leaving" < "Date Of Joining the Company" then Error(Txt002);
                        "Left social Club?" := true;
                    end;
                end;
            end;
        }
        field(39003906; "Termination Grounds"; Option)
        {
            OptionCaption = ' ,Resignation,Non-Renewal Of Contract,Dismissal,Retirement,Death,Other';
            OptionMembers = " ",Resignation,"Non-Renewal Of Contract",Dismissal,Retirement,Death,Other;
        }
        field(39003907; "Cell Phone Number"; Text[15])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(50600; "Job Group"; Code[20])
        {
            Caption = 'Job Level';
            TableRelation = "HR Job Grades".Code;
            trigger OnValidate()
            begin
                //TestField("Work Station");
                // if (Division = '') and ("Global Dimension 3 Code" = '') then begin
                //     Error('The staff must be assigned a branch or division');
                // end;
                //Validate(Grade);
                if rec."Manual Salary Negotiation"=true then
                Error('You cannot select Job Level if salary is manually adjusted');
            end;
        }
        field(50601; Select; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(50602; "Division Name"; Text[100])
        {
            Editable = false;
        }
        field(50603; "Branch- Name"; Text[100])
        {
            Editable = false;
        }
        field(50604; "Process Advance"; Boolean)
        {
            //TableRelation="Staff Advance Header"."Send to payroll" where(Status=filter(Approved),"Send to payroll"=const(true),"Payroll processed"=const(false),Posted=const(false),"Advance Closed"=const(false),"Staff ID"=field("No."));
        }
        field(50605; "Transport Allowance"; Option)
        {
            OptionMembers = "","Office","Out-Of Office";
        }

        field(50606; "Works in Desert"; Boolean)
        {
            Caption = 'Works in Desert/Arid Areas';
        }
        field(50607; "FYDA"; code[50]) { }
        field(50608;"Manual Salary Negotiation";boolean){
            trigger OnValidate()
            var
            ask:boolean;
            prsalcard: Record "HR-Employee";
            begin
                if rec."Manual Salary Negotiation"=true then
                ask:=Confirm('Do you wish to manually input the salaries now?');
                if ask=true then begin
                    prsalcard.Reset();
                    prsalcard.SetRange(prsalcard."No.",rec."No.");
                    if prsalcard.FindFirst() then begin
                        page.Run(Page::"PR Header Salary Card - ALL",prsalcard);

                    end else if not prsalcard.Find() then begin
                        Error('Salary Card not ready');
                    end


                end else begin
                    Message('Kindly remember to enter the salaries on the salary card');
                end;

            end;
        }

        //field(50603;"Branch Name";Text[100]){}
        field(39003908; Grade;Integer)
        {
            caption = 'Salary Grade';

            // TableRelation = "HR Job Grades".Code;
            //TableRelation = "Sal Grades"."Salary Grade";
            //testfield(global di)
            TableRelation = "Sal Grades"."Salary Grade" where("Job Group" = field("Job Group"));
            trigger OnValidate()
            var
                salgrade: record "Sal Grades";
                hrjobs: record "HR Jobs";
                salcard: Record "PR Salary Card";
                prperiods: Record "PR Payroll Periods";
                prtrans: Record "PR Employee Transactions";
                branches: record Branches;
                openperiod: date;
                periodmonth: Integer;
                periodyear: integer;
                vitalsetup: record "PR Vital Setup Info";
                hardship: record "Hardhsip Rates";
                fuel: record "Travel Allowance Rates";
                inbranch: boolean;
                basic: Decimal;
                managerial: Boolean;
                branchtaxed: Boolean;
            begin
                if rec."Manual Salary Negotiation"=true then
                Error('You cannot select Job Level if salary is manually adjusted');
                if (rec."Manual Salary Negotiation"=false) then
                openperiod := 0D;
                basic := 0;
                branchtaxed := true;
                //TestField("Work Station");
                TestField("Job ID");
                TestField("Job Group");
                inbranch := false;
                managerial := false;
                vitalsetup.Get();
                vitalsetup.TestField("Mobi all code");
                vitalsetup.TestField("Mobi all code Nontax");
                vitalsetup.TestField("House all code");
                vitalsetup.TestField("House all code nontax");
                vitalsetup.TestField("Position all code");
                vitalsetup.TestField("Position all code nontax");
                vitalsetup.TestField("Fuel all code");
                vitalsetup.TestField("Fuel all code nontax");
                vitalsetup.TestField("Hardship all code");
                vitalsetup.TestField("Hardship all code nontax");
                vitalsetup.TestField("Fuel Rate");
                vitalsetup.TestField("Fuel all code nontax");
                vitalsetup.TestField("House Allowance Percentage");
                salcard.Reset();
                salcard.SetRange(salcard."Employee Code", "No.");
                if salcard.FindFirst() then begin
                    //update the current salary parameters
                    prperiods.Reset();
                    prperiods.SetRange(prperiods.Closed, false);
                    if prperiods.FindFirst() then begin
                        openperiod := prperiods."Date Opened";
                        periodmonth := prperiods."Period Month";
                        periodyear := prperiods."Period Year";
                        if openperiod <> 0D then begin
                            salcard."Period Filter" := openperiod;
                            salcard."Pays PAYE" := true;
                            salcard."Pays Pension" := true;                   //salcard.Insert;                    
                                                                              //insert main allowances
                            salgrade.Reset();
                            salgrade.SetRange(salgrade."Job Group", "Job Group");
                            salgrade.SetRange(salgrade."Salary Grade", Grade);
                            if salgrade.FindFirst() then begin
                                salcard."Basic Pay" := salgrade.Basic_salary;
                                basic := salgrade.Basic_salary;
                                managerial := salgrade.Managerial;
                                salcard.modify;
                                //Validate("Basic Pay");

                                //Delete()
                                prtrans.Reset();
                                prtrans.SetRange(prtrans."Payroll Period", openperiod);
                                prtrans.SetRange(prtrans."Employee Code", "No.");
                                if prtrans.Find('-') then begin
                                    repeat

                                        if (prtrans."Transaction Code" = vitalsetup."House all code") or (prtrans."Transaction Code" = vitalsetup."House all code nontax") or (prtrans."Transaction Code" = vitalsetup."Mobi all code") or (prtrans."Transaction Code" = vitalsetup."Mobi all code Nontax") or
                                        (prtrans."Transaction Code" = vitalsetup."Position all code") or (prtrans."Transaction Code" = vitalsetup."Position all code nontax") or (prtrans."Transaction Code" = vitalsetup."Fuel all code") or (prtrans."Transaction Code" = vitalsetup."Fuel all code nontax") or
                                        (prtrans."Transaction Code" = vitalsetup."Hardship all code") or (prtrans."Transaction Code" = vitalsetup."Hardship all code nontax") then begin
                                            prtrans.Delete;
                                        end;
                                    until prtrans.next = 0;
                                end;

                                Sleep(20);
                                prtrans.Init;
                                prtrans."Payroll Period" := openperiod;
                                prtrans."Employee Code" := "No.";
                                if branchtaxed = true then begin
                                    prtrans."Transaction Code" := vitalsetup."House all code";
                                end else if branchtaxed = false then begin
                                    prtrans."Transaction Code" := vitalsetup."House all code nontax";
                                end;
                                prtrans.Validate("Transaction Code");
                                prtrans.Amount := salgrade."House Allowance";
                                prtrans."Period Month" := periodmonth;
                                prtrans."Period Year" := periodyear;
                                if prtrans.Amount <> 0 then begin
                                    prtrans.Insert;
                                end;
                                Sleep(20);

                                Sleep(20);
                                prtrans.Init;
                                prtrans."Payroll Period" := openperiod;
                                prtrans."Employee Code" := rec."No.";
                                if branchtaxed = true then begin
                                    prtrans."Transaction Code" := vitalsetup."Mobi all code";
                                end else if branchtaxed = false then begin
                                    prtrans."Transaction Code" := vitalsetup."Mobi all code";
                                end;
                                prtrans.Validate("Transaction Code");
                                prtrans.Amount := salgrade."Transport Allowance";
                                prtrans."Period Month" := periodmonth;
                                prtrans."Period Year" := periodyear;
                                if prtrans.Amount <> 0 then begin
                                    prtrans.Insert;
                                end;
                                Sleep(20);

                                Sleep(20);
                                prtrans.Init;
                                prtrans."Payroll Period" := openperiod;
                                prtrans."Employee Code" := rec."No.";
                                if branchtaxed = true then begin
                                    prtrans."Transaction Code" := vitalsetup."Position all code";
                                end else if branchtaxed = false then begin
                                    prtrans."Transaction Code" := vitalsetup."Position all code nontax";
                                end;
                                prtrans.Validate("Transaction Code");
                                prtrans.Amount := salgrade."Position Allowance";
                                prtrans."Period Month" := periodmonth;
                                prtrans."Period Year" := periodyear;
                                if prtrans.Amount <> 0 then begin
                                    prtrans.Insert;
                                end;
                                Sleep(20);

                            end else if not salgrade.Find() then begin
                                Error('This salary grade is not setup');


                            end;
                        end;

                        //insert hardship allowances
                        vitalsetup.Get();
                        if (vitalsetup."Hardship all code" <> '') and ("Work Station" <> '') then begin
                            // branchesdivRec.Reset();
                            // branchesdivRec.SetRange(branchesdivRec."Department/District Code","Work Station");
                            // branchesdivRec.SetRange(branchesdivRec.level,branchesdivRec.level::Branch);
                            // if branchesdivRec.FindFirst() then begin
                            //     inbranch:=true;
                            hardship.Reset();
                            hardship.SetRange(hardship."Region Code", rec.Region);
                            if hardship.FindFirst() then begin
                                prtrans.Init;
                                prtrans."Payroll Period" := openperiod;
                                prtrans."Employee Code" := rec."No.";
                                if branchtaxed = true then begin
                                    prtrans."Transaction Code" := vitalsetup."Hardship all code";
                                end else if branchtaxed = false then begin
                                    prtrans."Transaction Code" := vitalsetup."Hardship all code nontax";
                                end;
                                prtrans.Validate("Transaction Code");
                                //CalcFields("Basic Pay");
                                prtrans.Amount := (hardship."Rate(%)" / 100) * basic;
                                prtrans."Period Month" := periodmonth;
                                prtrans."Period Year" := periodyear;
                                if prtrans.Amount <> 0 then begin
                                    prtrans.Insert;
                                end;
                                Sleep(20);

                                //end;


                            end;

                        end else begin
                            //Enable if hardhsip is defined for outsourced resource
                            //Error('hardship allowance code has to be set in rates and ceilings(payroll)');
                        end;




                        //insert location based allowances
                        if ("Job Group" <> '') and ("Work Station" <> '') then begin
                            vitalsetup.Get();

                            fuel.reset;
                            fuel.SetRange(fuel."Job Grade", "Job Group");
                            if "Global Dimension 3 Code" <> '' then begin
                                fuel.SetRange(fuel.level, fuel.level::Branch);
                            end;
                            if Division <> '' then begin
                                fuel.SetRange(fuel.level, fuel.level::Division);
                            end;
                            if fuel.FindFirst() then begin
                                fuel.TestField(Amount);
                                prtrans.Init;
                                prtrans."Payroll Period" := openperiod;
                                prtrans."Employee Code" := rec."No.";
                                if branchtaxed = true then begin
                                    prtrans."Transaction Code" := vitalsetup."Fuel all code";
                                end else if branchtaxed = false then begin
                                    prtrans."Transaction Code" := vitalsetup."Fuel all code nontax";
                                end;
                                prtrans.Validate("Transaction Code");
                                prtrans.Amount := fuel.Amount * vitalsetup."Fuel Rate";
                                prtrans."Period Month" := periodmonth;
                                prtrans."Period Year" := periodyear;
                                if prtrans.Amount <> 0 then begin
                                    prtrans.Insert;
                                end;
                                Sleep(20);

                            end;

                        end

                    end else begin
                        Error('There is no open payroll period');
                    end;

                end else if not salcard.find() then begin
                    //insert new employee details
                    //Get current period
                    prperiods.Reset();
                    prperiods.SetRange(prperiods.Closed, false);
                    if prperiods.FindFirst() then begin
                        openperiod := prperiods."Date Opened";
                        periodmonth := prperiods."Period Month";
                        periodyear := prperiods."Period Year";

                    end else begin
                        Error('There is no open payroll period');
                    end;


                    //first insert the new salcard
                    if openperiod <> 0D then begin
                        salcard.init;
                        salcard."Employee Code" := "No.";
                        salcard."Period Filter" := openperiod;
                        salcard."Pays PAYE" := true;
                        salcard."Pays Pension" := true;
                        //salcard.Insert;                    
                        //insert main allowances
                        salgrade.Reset();
                        salgrade.SetRange(salgrade."Job Group", "Job Group");
                        salgrade.SetRange(salgrade."Salary Grade", Grade);
                        if salgrade.FindFirst() then begin
                            salcard."Basic Pay" := salgrade.Basic_salary;
                            basic := salgrade.Basic_salary;
                            salcard.Insert;
                            //Validate("Basic Pay");
                            Sleep(20);
                            prtrans.Init;
                            prtrans."Payroll Period" := openperiod;
                            prtrans."Employee Code" := "No.";
                            if branchtaxed = true then begin
                                prtrans."Transaction Code" := vitalsetup."House all code";
                            end else if branchtaxed = false then begin
                                prtrans."Transaction Code" := vitalsetup."House all code nontax";
                            end;
                            prtrans.Validate("Transaction Code");
                            prtrans.Amount := salgrade."House Allowance";
                            prtrans."Period Month" := periodmonth;
                            prtrans."Period Year" := periodyear;
                            if prtrans.Amount <> 0 then begin
                                prtrans.Insert;
                            end;
                            Sleep(20);

                            Sleep(20);
                            prtrans.Init;
                            prtrans."Payroll Period" := openperiod;
                            prtrans."Employee Code" := rec."No.";
                            if branchtaxed = true then begin
                                prtrans."Transaction Code" := vitalsetup."Mobi all code";
                            end else if branchtaxed = false then begin
                                prtrans."Transaction Code" := vitalsetup."Mobi all code";
                            end;
                            prtrans.Validate("Transaction Code");
                            prtrans.Amount := salgrade."Transport Allowance";
                            prtrans."Period Month" := periodmonth;
                            prtrans."Period Year" := periodyear;
                            if prtrans.Amount <> 0 then begin
                                prtrans.Insert;
                            end;
                            Sleep(20);

                            Sleep(20);
                            prtrans.Init;
                            prtrans."Payroll Period" := openperiod;
                            prtrans."Employee Code" := rec."No.";
                            if branchtaxed = true then begin
                                prtrans."Transaction Code" := vitalsetup."Position all code";
                            end else if branchtaxed = false then begin
                                prtrans."Transaction Code" := vitalsetup."Position all code nontax";
                            end;
                            prtrans.Validate("Transaction Code");
                            prtrans.Amount := salgrade."Position Allowance";
                            prtrans."Period Month" := periodmonth;
                            prtrans."Period Year" := periodyear;
                            if prtrans.Amount <> 0 then begin
                                prtrans.Insert;
                            end;
                            Sleep(20);

                        end else if not salgrade.Find() then begin
                            Error('This salary grade is not setup');


                        end;
                    end;

                    //insert hardship allowances
                    vitalsetup.Get();
                    if (vitalsetup."Hardship all code" <> '') and (rec.Region <> '') then begin
                        // branchesdivRec.Reset();
                        // branchesdivRec.SetRange(branchesdivRec."Department/District Code","Work Station");
                        //branchesdivRec.SetRange(branchesdivRec.level,branchesdivRec.level::Branch);
                        hardship.Reset();                        
                        hardship.SetRange(hardship."Region Code", rec.Region);
                        if hardship.FindFirst() then begin
                            prtrans.Init;
                            prtrans."Payroll Period" := openperiod;
                            prtrans."Employee Code" := rec."No.";
                            if branchtaxed = true then begin
                                prtrans."Transaction Code" := vitalsetup."Hardship all code";
                            end else if branchtaxed = false then begin
                                prtrans."Transaction Code" := vitalsetup."Hardship all code nontax";
                            end;
                            prtrans.Validate("Transaction Code");
                            //CalcFields("Basic Pay");

                            prtrans.Amount := (hardship."Rate(%)" / 100) * basic;
                            prtrans."Period Month" := periodmonth;
                            prtrans."Period Year" := periodyear;
                            if prtrans.Amount <> 0 then begin
                                prtrans.Insert;
                            end;
                            Sleep(20);

                            //end;


                        end;

                    end else begin
                        //Error('hardship allowance code has to be set in rates and ceilings(payroll) Or Check if Work Station is filled');
                    end;




                    //insert location based allowances
                    if ("Job Group" <> '') and ("Work Station" <> '') then begin
                        vitalsetup.Get();

                        fuel.reset;
                        fuel.SetRange(fuel."Job Grade", "Job Group");
                        if "Global Dimension 3 Code" <> '' then begin
                            fuel.SetRange(fuel.level, fuel.level::Branch);
                        end;
                        if Division <> '' then begin
                            fuel.SetRange(fuel.level, fuel.level::Division);
                        end;
                        if fuel.FindFirst() then begin
                            fuel.TestField(Amount);
                            prtrans.Init;
                            prtrans."Payroll Period" := openperiod;
                            prtrans."Employee Code" := rec."No.";
                            if branchtaxed = true then begin
                                prtrans."Transaction Code" := vitalsetup."Fuel all code";
                            end else if branchtaxed = false then begin
                                prtrans."Transaction Code" := vitalsetup."Fuel all code nontax";
                            end;
                            prtrans.Validate("Transaction Code");
                            prtrans.Amount := fuel.Amount * vitalsetup."Fuel Rate";
                            prtrans."Period Month" := periodmonth;
                            prtrans."Period Year" := periodyear;
                            if prtrans.Amount <> 0 then begin
                                prtrans.Insert;
                            end;
                            Sleep(20);

                        end;

                    end


                end;

            end;
        }
        field(39003909; "Employee UserID"; Code[70])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(39003910; "Leave Balance"; Decimal)
        {
            CalcFormula = sum("HR Leave Allocation"."No. of days" where("No." = field("No."),
                                                                              "Posting Date" = field("Date Filter"),
                                                                             "Leave Type" = filter('ANNUAL'),
                                                                             //"Posting Type" = filter('Normal'),//felix
                                                                             Closed = const(false),
                                                                             "Calendar Code" = field("Current HR Calender")));
            FieldClass = FlowField;
        }
        field(39003911; "Leave Status"; Option)
        {
            OptionCaption = ' ,On Leave,Resumed';
            OptionMembers = " ","On Leave",Resumed;
        }
        field(39003912; "Pension Scheme Join Date"; Date) { }
        field(39003913; "Medical Scheme Join Date"; Date) { }


        field(39003914; "Leave Type Filter"; Code[20])
        {
            TableRelation = "Leave Types";
        }
        field(39003915; "Balance B/F"; Decimal)
        {
            CalcFormula = sum("HR Leave Ledger"."No. of days" where("Employee No" = field("No."),
                                                                             "Transaction Date" = field("Date Filter"),
                                                                             "Leave Type" = filter('ANNUAL'),
                                                                             Closed = const(false),
                                                                            "Entry Type" = filter(Allocation)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39003925; "Basic Pay"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PR Salary Card"."Basic Pay" where("Employee Code" = field("No.")));
        }
        field(39003928; "Last Date Modified By"; Code[50])
        {
            Editable = false;
        }
        field(39003930; "Global Dimension 1 Name"; Text[60])
        {
            Editable = false;
        }
        field(39003931; "Global Dimension 2 Name"; Text[55])
        {
            Editable = false;
        }
        field(39003932; "Is at HQ?"; Boolean)
        {
            CalcFormula = exist("User Setup" where("User ID" = field("User ID")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39003933; "Supervisor User ID"; Code[70])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(39003934; "HOD User ID"; Code[70])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(39003935; "Type Of Disability"; Text[10])
        {

            TableRelation = "HR Lookup Values".Code where(Type = filter("Disability Type"));
        }
        field(39003936; "Work Station"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                          "Dimension Value Type" = const(Standard));
            trigger OnValidate()
            begin
                if (Grade <> 0) and ("Job Group" <> '') then begin

                    Validate(Grade);
                end

            end;
        }
        field(39003937; "Notification Date"; Date) { }
        field(39003938; "Region Name"; Text[100])
        {
            Editable = false;
        }
        field(39003939; "No Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(39003940; "Is Paid Daily?"; Boolean) { }
        field(39003941; DOL; Date) { }
        field(39003944; "Payroll Period Date Deactive"; Date)
        {
            Caption = 'Payroll Period Date Deactivated';
        }
        field(39003945; "Carry forward"; Decimal)
        {
            CalcFormula = sum("HR Leave Allocation"."No. of days" where("No." = field("No."),

                                                                             "Leave Type" = filter('ANNUAL'),
                                                                             "Posting Type" = filter("Carry Forward"),
                                                                             Closed = const(false),
                                                                             "Calendar Code" = field("Current HR Calender"),
                                                                             "Entry Type" = filter("Positive Adjustment")));
            FieldClass = FlowField;
        }
        field(39003946; "Available Days"; Decimal) { }
        field(39003947; "Last Modified By"; Code[30]) { }
        field(39003948; Reestablish; Boolean) { }
        field(39003949; Driver; Boolean) { }
        field(39003950; "Date of First Appointment"; date) { }
        field(39003951; "On Leave"; Boolean) { }
        field(39003952; "Current Leave No"; code[20]) { }
        field(39003953; "Period Year Filter"; Integer)
        {
            FieldClass = FlowFilter;
        }


        field(39003954; "BRS Staff No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }

        field(39003960; "From IPPD"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(39003961; "Previous Payment System"; code[50])
        {
            DataClassification = ToBeClassified;
        }

        field(39003962; "Bank Name"; Code[100])
        {
            //Editable = false;
        }

        field(39003963; "Branch Name"; Code[100])
        {
            //Editable = false;
        }

        field(39003964; "Bank and Branch Code"; Code[20]) { }

        field(390003958; "Seconded Duration"; DateFormula)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                //TestField("Seconded Start Date");
                "Seconded End Date" := CalcDate("Seconded Duration", "Seconded Start Date");
            end;
        }
        field(390039555; "Old Staff No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }

        field(390039556; "Employee Contract Type"; Option)
        {
            OptionMembers = "","Permanent and Pensionable","Contract","Probation","Casual","Intern","Seconded";
            DataClassification = ToBeClassified;
        }

        field(390039557; "Seconded Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                // TestField("Seconded Duration");
                // TestField("Employee Type", "Employee Type"::Seconded);
            end;

        }
        field(390039559; "Seconded End Date"; date)
        {
            DataClassification = ToBeClassified;
        }
        field(390039560; "Portal Password"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(390039561; "Verification Token"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(390039562; "Verified"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(390039563; "Portal OTP Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(390039564; "Portal OTP Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(390039565; "Portal OTP Device"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(390039566; "Portal Reset Token"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(390039567; "Portal Reset Token Expired"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(390039568; "OTP Code Used Today"; Boolean)
        {
            DataClassification = ToBeClassified;
        }



    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "First Name") { }
        key(Key3; "Middle Name") { }
        key(Key4; "Last Name") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Initials, "First Name", "Middle Name", "Last Name") { }
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            /*  TheTable.RESET;
             IF TheTable.FINDLAST THEN BEGIN
                 "No." := INCSTR(TheTable."No.")
             END ELSE BEGIN
                 "No." := 'BRS-ANNUAL';
             END; */
            if "No." <> xRec."No." then begin
                HRSetup.Get;
                HRSetup.TestField("Employee Nos.");
                NoSeriesMgt.TestManual(HRSetup."Employee Nos.");
                "No. Series" := '';
            end;

        END;

    end;

    trigger OnModify()
    begin

        "Last Date Modified" := TODAY;
        "Last Date Modified By" := USERID;
    end;

    var
        Txt003: label 'Date of Join can not be greater than Today';
        Txt002: label 'Date of Leaving can not be less than Date of Joining the Company ';
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        DimVal: Record "Dimension Value";
        salgrades: record "Sal Grades";
        branchgrade: Record "Branch Grading";
        //dimval: Record "Dimension Value";
        distrctsdepartRec: Record Departments;
        branchesdivRec: Record Branches;

        departmentsRec: Record Departments;

        sectorsRec: Record Sectors;


        organogra: Record Organogram;

    procedure AssistEdit(OldEmployee: Record "HR-Employee"): Boolean
    begin
    end;

    local procedure fn_FullName()
    begin
        /*
        "Full Name":="First Name"+' '+"Middle Name"+' '+"Last Name";
        */

    end;

    local procedure calcannualleave(Rec: Record "HR-Employee")
    var
        hrcalendar: record "HR Leave Calendar";
        leavetypes: record "Leave Types";
        nooftwos: integer;
        nooftwos1: decimal;
        LineNo: Integer;
        incrementby: decimal;
        numberofyears: integer;
        lenghtofservce: Integer;
        lenghtofservce1: Decimal;
        HRLeaveAllocation: Record "HR Leave Allocation";
        Postentries: Codeunit "HR Post Leave Journal Ent.";
    //Hr cale
    begin
        nooftwos := 0;
        incrementby := 0;
        numberofyears := 0;
        lenghtofservce := 0;
        lenghtofservce := 0;
        nooftwos1 := 0;
        hrcalendar.Reset();
        hrcalendar.SetRange(hrcalendar.Current, true);
        if hrcalendar.FindFirst() then begin
            hrcalendar.TestField("Start Date");
            hrcalendar.TestField("End Date");
            if hrcalendar."End Date" < today then begin
                Error('You dont have a hr leave calendar');
            end else begin

                leavetypes.Reset();
                leavetypes.SetRange(leavetypes.Annual, true);
                if leavetypes.FindFirst() then begin
                    leavetypes.TestField("Years to Consider for Increment");
                    leavetypes.TestField("No of Days to Increment with");
                    leavetypes.TestField(Days);
                    numberofyears := leavetypes."Years to Consider for Increment";
                    incrementby := leavetypes."No of Days to Increment with";
                    rec.Testfield("Date Of Joining the Company");
                    if rec."Date Of Joining the Company" < hrcalendar."Start Date" then begin
                        lenghtofservce := hrcalendar."Start Date" - rec."Date Of Joining the Company";
                        //Message(Format(lenghtofservce));
                        lenghtofservce1 := lenghtofservce / 365;
                        lenghtofservce := Round(lenghtofservce1, 1, '=');
                        if lenghtofservce1 <> 0 then begin
                            nooftwos1 := lenghtofservce1 / 2;
                            nooftwos := Round(nooftwos1, 1, '=');


                        end;
                    end;
                    if lenghtofservce >= (365 * 2) then
                        HRLeaveAllocation.Reset();
                    HRLeaveAllocation.SetRange(HRLeaveAllocation."Leave Type", leavetypes.Code);
                    HRLeaveAllocation.SetRange(HRLeaveAllocation."No.", "No.");
                    HRLeaveAllocation.SetRange(HRLeaveAllocation.Posted, true);
                    HRLeaveAllocation.SetRange(HRLeaveAllocation."Calendar Start Date", hrcalendar."Start Date");
                    HRLeaveAllocation.SetRange(HRLeaveAllocation."Calendar End Date", hrcalendar."End Date");
                    HRLeaveAllocation.SetRange(HRLeaveAllocation."Entry Type", HRLeaveAllocation."Entry Type"::"Positive Adjustment");
                    if HRLeaveAllocation.FindFirst() then begin

                    end else if not HRLeaveAllocation.Find() then begin



                        HRLeaveAllocation.Reset();
                        HRLeaveAllocation.SetRange(Posted, false);
                        if not HRLeaveAllocation.IsEmpty() then HRLeaveAllocation.DeleteAll();
                        sleep(10);
                        LineNo := LineNo + 1;

                        HRLeaveAllocation.Init;
                        HRLeaveAllocation."Entry No." := LineNo;

                        HRLeaveAllocation."No. Of days" := leavetypes.Days + nooftwos1;
                        HRLeaveAllocation."Calendar Code" := hrcalendar.Code;

                        HRLeaveAllocation."No." := rec."No.";
                        HRLeaveAllocation."Staff Name" := Rec."First Name" + ' ' + Rec."Middle Name" + ' ' + Rec."Last Name";

                        HRLeaveAllocation."Posting Date" := hrcalendar."Start Date";
                        HRLeaveAllocation."Leave Type" := leavetypes.Code;
                        HRLeaveAllocation."Entry Type" := HRLeaveAllocation."Entry Type"::"Positive Adjustment";
                        HRLeaveAllocation."Posting Description" := ' Allocation - ' + Format(Today);
                        HRLeaveAllocation."Posted By" := UserId;

                        HRLeaveAllocation.Posted := false;
                        HRLeaveAllocation."Calendar Start Date" := hrcalendar."Start Date";
                        HRLeaveAllocation."Calendar End Date" := hrcalendar."End Date";
                        HRLeaveAllocation."Document No." := 'BATCH-' + hrcalendar.Code;
                        HRLeaveAllocation."Posting Source" := HRLeaveAllocation."posting source"::Batch;
                        HRLeaveAllocation.Closed := false;
                        HRLeaveAllocation.Insert;


                        HRLeaveAllocation.Reset();
                        HRLeaveAllocation.SetRange(HRLeaveAllocation."No.", rec."No.");
                        HRLeaveAllocation.SetRange(HRLeaveAllocation."Leave Type", leavetypes.Code);
                        HRLeaveAllocation.SetRange(HRLeaveAllocation."Posting Date", hrcalendar."Start Date");
                        if HRLeaveAllocation.FindFirst() then begin
                            HRLeaveAllocation."Posted By" := UserId;
                            HRLeaveAllocation.Posted := true;
                            HRLeaveAllocation.Closed := false;
                            HRLeaveAllocation.Modify;
                            Postentries.PostLeaveAllocation(HRLeaveAllocation."Entry No.", HRLeaveAllocation."No.", HRLeaveAllocation."Leave Type", HRLeaveAllocation."Calendar Code");


                        end;
                    end;












                    //end;




                    //end;


                end else begin
                    Error('You must setup annual leave');
                end;

            end;

        end else begin
            Error('You dont have a hr leave calendar');
        end;


    end;



    local procedure PostPromotion(Rec: Record "HR-Employee")
    var

        internalpromotion: Record "Internal Employment History";
    begin
        internalpromotion.Reset();
        internalpromotion.SetRange(internalpromotion.Promotion_No, Rec."No.");
        if internalpromotion.FindFirst() then begin
            message('This employee internal employement history is already updated');
        end else if not internalpromotion.find() then begin
            internalpromotion.Init();
            internalpromotion.Promotion_No := rec."No.";
            internalpromotion.current := true;
            internalpromotion.Validate(current);
            internalpromotion.From := rec."Date Of Joining the Company";
            internalpromotion."To Date" := rec."Contract End Date";
            internalpromotion."Employee No." := rec."No.";
            internalpromotion.Status := internalpromotion.Status::Approved;
            internalpromotion."Reason for Change" := internalpromotion."Reason for Change"::Employment;
            internalpromotion."Reason Description" := 'Employement Contract';
            internalpromotion.Comment := '';
            internalpromotion."Global Dimension 2 Code" := rec."Global Dimension 1 Code";
            internalpromotion."Global Dimension 3 Code" := rec."Global Dimension 3 Code";
            internalpromotion.Division := rec.Division;
            internalpromotion.District := rec."Business Unit";
            internalpromotion."Work Station" := rec."Work Station";
            internalpromotion.Grade := rec.grade;
            internalpromotion.Sector := rec.Sector;
            internalpromotion."Job ID" := rec."Job ID";
            internalpromotion."Key Experience" := 'As per CV, view external work history';
            internalpromotion."Promoted to HoD" := rec."Is HOD";
            internalpromotion.Insert;
            Message('Internal history of employment updated');
        end;
        //Error('Procedure PostPromotion not implemented.');

    end;

    local procedure Posttemp(Rec: Record "HR-Employee")
    var

        internalpromotion: Record "Internal Employment History";
    begin
        internalpromotion.Reset();
        internalpromotion.SetRange(internalpromotion.Promotion_No, Rec."No.");
        if internalpromotion.FindFirst() then begin
            message('This employee internal employement history is already updated');
        end else if not internalpromotion.find() then begin
            internalpromotion.Init();
            internalpromotion.Promotion_No := rec."No.";
            internalpromotion.current := true;
            internalpromotion.Validate(current);
            internalpromotion.From := rec."Date Of Joining the Company";
            internalpromotion."To Date" := rec."Contract End Date";
            internalpromotion."Employee No." := rec."No.";
            internalpromotion.Status := internalpromotion.Status::Approved;
            internalpromotion."Reason for Change" := internalpromotion."Reason for Change"::Employment;
            internalpromotion."Reason Description" := 'Employement Contract';
            internalpromotion.Comment := '';
            internalpromotion."Global Dimension 1 Code" := rec."Global Dimension 1 Code";
            internalpromotion."Global Dimension 2 Code" := rec."Global Dimension 2 Code";
            internalpromotion.Division := rec.Division;
            internalpromotion.District := rec."Business Unit";
            internalpromotion."Work Station" := rec."Work Station";
            internalpromotion.Grade := rec."Salary Grade";
            internalpromotion.Sector := rec.Sector;
            internalpromotion."Job ID" := rec."Job ID";
            internalpromotion."Key Experience" := 'As per CV, view external work history';
            internalpromotion."Promoted to HoD" := rec."Is HOD";
            internalpromotion.Insert;
            Message('Internal history of employment updated');
        end;
        //Error('Procedure PostPromotion not implemented.');

    end;

    local procedure allcoatetransportallowance(empno: code[20]; transinternal: Boolean; transexternal: Boolean)
    var
        prperiods: Record "PR Payroll Periods";
        premptrans: record "PR Employee Transactions";
        vitalsetups: Record "PR Vital Setup Info";
        prcard: Record "PR Salary Card";
        taxableamt: Decimal;
        nontaxableamt: Decimal;
        allowancegross: Decimal;
    begin
        taxableamt := 0;
        nontaxableamt := 0;
        allowancegross := 0;
        //check if active
        prcard.Reset();
        prcard.SetRange(prcard."Employee Code", empno);
        if prcard.FindFirst() then begin
            //check if there's active payroll period
            prperiods.Reset();
            prperiods.SetRange(prperiods.Closed, false);
            if prperiods.FindFirst() then begin
                if prperiods."Date Opened" <> 0D then begin
                    //check vitalsetups
                    vitalsetups.Get();
                    vitalsetups.TestField("Taxable Trans Allow Code");
                    vitalsetups.TestField("NonTaxable Trans Allow Code");
                    vitalsetups.TestField("Out of Office Max Allowance");
                    vitalsetups.TestField("Working in Office Tra");
                    vitalsetups.TestField("Transport Allowance Percentage");
                    rec.TestField("Job Group");
                    rec.TestField(Grade);
                    rec.CalcFields("Basic Pay");
                    if (rec."Basic Pay" = 0) then begin
                        Error('Kindly assign the employee basic pay via the salary grade page');
                    end else if rec."Basic Pay" <> 0 then begin

                        //delete current existing transport allowances to accomodate change
                            premptrans.SetRange(premptrans."Employee Code", empno);
                            premptrans.SetRange(premptrans."Payroll Period", prperiods."Date Opened");
                            premptrans.SetRange(premptrans."Transaction Code", vitalsetups."NonTaxable Trans Allow Code");
                            if premptrans.FindFirst() then begin
                                premptrans.Delete;
                                //premptrans.Modify;

                            end else if not premptrans.Find() then begin
                             premptrans.SetRange(premptrans."Employee Code", empno);
                            premptrans.SetRange(premptrans."Payroll Period", prperiods."Date Opened");
                            premptrans.SetRange(premptrans."Transaction Code", vitalsetups."Taxable Trans Allow Code");
                            if premptrans.FindFirst() then begin

                                premptrans.Delete;
                                //premptrans.Modify;
                            end

                            end;


                        
                        //time to insert the pr employee transactions
                        //but first get taxable and non-taxable for working outside office
                        if transexternal = true then begin
                            allowancegross := (vitalsetups."Transport Allowance Percentage" / 100) * rec."Basic Pay";
                            if allowancegross > vitalsetups."Out of Office Max Allowance" then begin
                                allowancegross := vitalsetups."Out of Office Max Allowance";
                            end else begin
                                allowancegross := allowancegross;
                            end;
                            if allowancegross <> 0 then
                                if allowancegross > vitalsetups."Defined Maximum Fuel Allowance" then begin
                                    nontaxableamt := allowancegross;
                                    taxableamt := 0;
                                end else begin
                                    nontaxableamt := allowancegross;
                                end;
                        end;
                        //now get taxable and non taxable for in office workers
                        if transinternal = true then begin
                            allowancegross := vitalsetups."Working in Office Tra";
                            if allowancegross <> 0 then
                                if allowancegross > vitalsetups."Defined Maximum Fuel Allowance" then begin
                                    nontaxableamt := vitalsetups."Defined Maximum Fuel Allowance";
                                    taxableamt := allowancegross - vitalsetups."Defined Maximum Fuel Allowance";
                                end else begin
                                    nontaxableamt := allowancegross;
                                end;
                        end;

                        //if (taxableamt<>0) or (nontaxableamt<>0) then  
                        //now insert if one has value       

                        if nontaxableamt <> 0 then begin
                            premptrans.Reset();
                            premptrans.SetRange(premptrans."Employee Code", empno);
                            premptrans.SetRange(premptrans."Payroll Period", prperiods."Date Opened");
                            premptrans.SetRange(premptrans."Transaction Code", vitalsetups."NonTaxable Trans Allow Code");
                            if premptrans.FindFirst() then begin
                                premptrans.Amount := nontaxableamt;
                                premptrans.Validate("Transaction Code");
                                premptrans.Modify;

                            end else if not premptrans.Find() then begin
                                premptrans.Init;
                                premptrans."Transaction Code" := vitalsetups."NonTaxable Trans Allow Code";
                                premptrans.Validate("Transaction Code");
                                premptrans."Employee Code" := empno;
                                premptrans."Payroll Period" := prperiods."Date Opened";
                                premptrans."Period Month" := Date2DMY(prperiods."Date Opened", 2);
                                premptrans."Period Year" := Date2DMY(prperiods."Date Opened", 3);
                                premptrans.Amount := nontaxableamt;
                                premptrans.Insert;
                            end;

                        end;

                        if taxableamt <> 0 then begin

                            premptrans.Reset();
                            premptrans.SetRange(premptrans."Employee Code", empno);
                            premptrans.SetRange(premptrans."Payroll Period", prperiods."Date Opened");
                            premptrans.SetRange(premptrans."Transaction Code", vitalsetups."Taxable Trans Allow Code");
                            if premptrans.FindFirst() then begin
                                premptrans.Amount := taxableamt;
                                premptrans.Validate("Transaction Code");
                                premptrans.Modify;

                            end else if not premptrans.Find() then begin
                                premptrans.Init;
                                premptrans."Transaction Code" := vitalsetups."Taxable Trans Allow Code";
                                premptrans.Validate("Transaction Code");
                                premptrans."Employee Code" := empno;
                                premptrans."Payroll Period" := prperiods."Date Opened";
                                premptrans."Period Month" := Date2DMY(prperiods."Date Opened", 2);
                                premptrans."Period Year" := Date2DMY(prperiods."Date Opened", 3);
                                premptrans.Amount := taxableamt;
                                premptrans.Insert;
                            end;

                        end;

                    end;



                end else begin
                    Error('There is no open Payroll period and thus allocation cannot be made');
                end;

            end else if not prperiods.Find() then begin
                Error('There is no open Payroll period and thus allocation cannot be made');
            end;

        end else begin
            Error('Employee not updated on the Payroll Listings, 1. Try to close the card and reopen or 2. Consult Payroll manager');
        end;


    end;

    local procedure Postacting(Rec: Record "HR-Employee")
    var

        internalpromotion: Record "Internal Employment History";
    begin
        internalpromotion.Reset();
        internalpromotion.SetRange(internalpromotion.Promotion_No, Rec."No.");
        if internalpromotion.FindFirst() then begin
            message('This employee internal employement history is already updated');
        end else if not internalpromotion.find() then begin
            internalpromotion.Init();
            internalpromotion.Promotion_No := rec."No.";
            internalpromotion.current := true;
            internalpromotion.Validate(current);
            internalpromotion.From := rec."Date Of Joining the Company";
            internalpromotion."To Date" := rec."Contract End Date";
            internalpromotion."Employee No." := rec."No.";
            internalpromotion.Status := internalpromotion.Status::Approved;
            internalpromotion."Reason for Change" := internalpromotion."Reason for Change"::Employment;
            internalpromotion."Reason Description" := 'Employement Contract';
            internalpromotion.Comment := '';
            internalpromotion."Global Dimension 2 Code" := rec."Global Dimension 1 Code";
            internalpromotion."Global Dimension 3 Code" := rec."Global Dimension 3 Code";
            internalpromotion.Division := rec.Division;
            //internalpromotion.District := rec.District;
            internalpromotion."Work Station" := rec."Work Station";
            internalpromotion.Grade := rec."Salary Grade";
            internalpromotion.Sector := rec.Sector;
            internalpromotion."Job ID" := rec."Job ID";
            internalpromotion."Key Experience" := 'As per CV, view external work history';
            internalpromotion."Promoted to HoD" := rec."Is HOD";
            internalpromotion.Insert;
            Message('Internal history of employment updated');
        end;
        //Error('Procedure PostPromotion not implemented.');

    end;
}

