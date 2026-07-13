Table 50475 "HR Employee2"
{
    Caption = 'Employee';
    //DataCaptionFields = "No.","Job Title","First Name","Middle Name","Last Name","Search Name";
    // DrillDownFormID = Form39005622;
    // LookupFormID = Form39005622;

    fields
    {
        field(1; "No."; Code[20])
        {
            NotBlank = false;


        }
        field(2; "First Name"; Text[30]) { }
        field(3; "Middle Name"; Text[30]) { }
        field(4; "Last Name"; Text[30]) { }
        field(5; Initials; Text[50])
        {
            //TableRelation = "Staff Title".Code;


        }
        field(7; "Search Name"; Code[50]) { }
        field(8; "Postal Address"; Text[10]) { }
        field(9; "Residential Address"; Text[20]) { }
        field(10; City; Text[20]) { }
        field(11; "Post Code"; Code[20])
        {
            //TableRelation = "Post Code";
            //This property is currently not supported
            //Test//TableRelation = false;



        }
        field(12; County; Text[20]) { 
            caption='Region';
        }
        field(13; "Home Phone Number"; Text[20]) { }
        field(14; "Cellular Phone Number"; Text[30]) { }
        field(15; "Work Phone Number"; Text[20]) { }
        field(16; "Ext."; Text[10]) { }
        field(17; "E-Mail"; Text[70]) { }
        field(19; Picture; Blob)
        {
            SubType = Bitmap;
        }
        field(21; "ID Number"; Text[20]) { }
        field(22; "Union Code"; Code[10])
        {
            //TableRelation = Union;
        }
        field(23; "UIF Number"; Text[10]) { }
        field(24; Gender; Option)
        {
            OptionMembers = Female,Male;
        }
        field(25; "Country Code"; Code[20])
        {
            //TableRelation = "Country/Region";
        }
        field(28; "Statistics Group Code"; Code[10])
        {
            //TableRelation = "Employee Statistics Group";
        }
        field(31; Status; Option)
        {
            OptionMembers = Normal,Resigned,Discharged,Retrenched,Pension,Disabled,Probation,Confirmed;


        }
        field(36; "Department Code"; Code[20])
        {
            //TableRelation = "Dimension Value".Code where ("Dimension Code"=const('DEPARTMENT'));

            trigger OnValidate()
            begin
                /*
                 { IF (("Department Code" <> xRec."Department Code") AND (xRec."Department Code" <> '')) THEN BEGIN
                      CareerEvent.SetMessage('Department Changed');
                      CareerEvent.RUNMODAL;
                      OK:= CareerEvent.ReturnResult;
                       IF OK THEN BEGIN
                          IF NOT CareerHistory.FIND('-') THEN
                           CareerHistory."Line No.":=1
                         ELSE BEGIN
                           CareerHistory.FIND('+');
                           CareerHistory."Line No.":=CareerHistory."Line No."+1;
                         END;
                          CareerHistory.INIT;
                          CareerHistory."Employee No.":= "No.";
                          CareerHistory."Date Of Event":= WORKDATE;
                          CareerHistory."Career Event":= 'Department Changed';
                          CareerHistory.Department:="Department Code";
                          CareerHistory."Employee First Name":= "Known As";
                          CareerHistory."Employee Last Name":= "Last Name";
                          CareerHistory.INSERT;
                       END;
                     //  Code below commented by Linus
                      {
                       IF ("Resource No." <> '') AND Res.WRITEPERMISSION THEN
                         EmployeeResUpdate.ResUpdate(Rec)
                      }
                   END;
                }
               //Added to change dept on employee table and assignment matrix table
               //employee payroll
               IF Payroll.GET("No.") THEN BEGIN
               Payroll."Department Code":="Department Code";
               Payroll.MODIFY;
               END;

               //
                GetPayPeriod;
               // "Payroll Period":=PayStartDate;
               //  "Pay Period":=PayPeriodText;

               //Employee No,Type,Code,Payroll Period,Department Code


               AssMatrix.RESET;
               AssMatrix.SETRANGE(AssMatrix."Employee No","No.");
               AssMatrix.SETRANGE("Payroll Period",PayStartDate);
               IF AssMatrix.FIND('-') THEN BEGIN
                REPEAT
                 AssMatrixTemp.TRANSFERFIELDS(AssMatrix);
                 AssMatrixTemp."Department Code":="Department Code";
                 AssMatrixTemp.INSERT;
                 AssMatrix.DELETE;
                UNTIL AssMatrix.NEXT=0;
               END;


               AssMatrixTemp.RESET;
               AssMatrixTemp.SETRANGE(AssMatrixTemp."Employee No","No.");
               AssMatrixTemp.SETRANGE("Payroll Period",PayStartDate);
               IF AssMatrixTemp.FIND('-') THEN BEGIN
                REPEAT
                 AssMatrix.TRANSFERFIELDS(AssMatrixTemp);
                 //AssMatrix."Department Code":="Department Code";
                 AssMatrix.INSERT;
                AssMatrixTemp.DELETE;
                UNTIL AssMatrixTemp.NEXT=0;
               END;
                */

            end;
        }
        field(37; Office; Code[10])
        {
            //TableRelation = "Dimension Value".Code where ("Dimension Code"=const('BRANCH'));


        }
        field(38; "Resource No."; Code[10])
        {
            //TableRelation = Resource;


        }
        field(39; Comment; Boolean)
        {
            //CalcFormula = exist("HR Human Resource Comments" where ("Table Name"=const(Employee),

            FieldClass = FlowField;
        }
        field(40; "Last Date Modified"; Date)
        {
            Editable = false;
        }
        field(41; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(42; "Department Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            //TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(3));
        }
        field(43; "Office Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            //TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(47; "Employee No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            //TableRelation = Employee;
        }
        field(49; "Fax Number"; Text[30]) { }
        field(50; "Company E-Mail"; Text[50]) { }
        field(51; Title; Option)
        {
            OptionCaption = 'MR,MRS,MISS,MS,DR,  ,CC,ASSCOC.PROF,PROF,REV.,REV. DR.';
            OptionMembers = MR,MRS,MISS,MS,DR,"  ",CC,"ASSCOC.PROF",PROF,"REV.","REV. DR.";


        }
        field(52; "Salespers./Purch. Code"; Code[20]) { }
        field(53; "No. Series"; Code[20])
        {
            Editable = false;
            //TableRelation = "No. Series";
        }
        field(54; "Known As"; Text[30]) { }
        field(55; Position; Text[10]) { }
        field(57; "Full / Part Time"; Option)
        {
            OptionMembers = "Full Time"," Part Time",Contract;


        }
        field(58; "Contract Type"; Code[10])
        {
            //TableRelation = "Contract Types".Contract;
        }
        field(59; "Contract End Date"; Date) { }
        field(60; "Notice Period"; Code[20])
        {
            //TableRelation = "HR Notice Period".Code;
        }
        field(61; "Union Member?"; Boolean) { }
        field(62; "Shift Worker?"; Boolean) { }
        field(63; "Contracted Hours"; Decimal) { }
        field(64; "Pay Period"; Option)
        {
            OptionMembers = Weekly,"2 Weekly","4 Weekly",Monthly," ";
        }
        field(65; "Pay Per Period"; Decimal) { }
        field(66; "Cost Code"; Code[20])
        {
            //TableRelation = "HR Cost Code";


        }
        field(68; "PAYE Number"; Text[30]) { }
        field(69; "UIF Contributor?"; Boolean) { }
        field(73; "Marital Status"; Option)
        {
            OptionMembers = " ",Single,Married,Separated,Divorced,"Widow(er)",Other;


        }
        field(74; "Ethnic Origin"; Option)
        {
            OptionMembers = African,Indian,White,Coloured;




        }
        field(75; "First Language (R/W/S)"; Code[20])
        {
            //TableRelation = "HR Language Preference";
        }
        field(76; "Driving Licence"; Code[20])
        {
            //TableRelation = "HR Drivers Licence";
        }
        field(77; "Vehicle Registration Number"; Code[20]) { }
        field(78; Disabled; Option)
        {
            OptionMembers = No,Yes," ";


        }
        field(79; "Health Assesment?"; Boolean) { }
        field(80; "Health Assesment Date"; Date) { }
        field(81; "Date Of Birth"; Date) { }
        field(82; Age; Text[50]) { }
        field(83; "Date Of Join"; Date) { }
        field(84; "Length Of Service"; Text[50]) { }
        field(85; "End Of Probation Date"; Date) { }
        field(86; "Pension Scheme Join"; Date) { }
        field(87; "Time Pension Scheme"; Text[20]) { }
        field(88; "Medical Scheme Join"; Date) { }
        field(89; "Time Medical Scheme"; Text[20])
        {
            //This property is currently not supported
            //Test//TableRelation = true;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //Validate//TableRelation = true;
        }
        field(90; "Date Of Leaving"; Date) { }
        field(91; Paterson; Code[20])
        {
            //TableRelation = "HR Paterson".Paterson;
        }
        field(92; Peromnes; Code[20])
        {
            //TableRelation = "HR Peromnes";
        }
        field(93; Hay; Code[20])
        {
            //TableRelation = "HR Hay".Hay;
        }
        field(94; Castellion; Code[20])
        {
            //TableRelation = "HR Castellion".Castillion;
        }
        field(95; "Per Annum"; Decimal) { }
        field(96; "Allow Overtime"; Option)
        {
            OptionMembers = Yes,No," ";
        }
        field(97; "Medical Scheme No."; Text[30]) { }
        field(98; "Medical Scheme Head Member"; Text[60]) { }
        field(99; "Number Of Dependants"; Integer)
        {

            trigger OnValidate()
            begin
                // MedicalAidBenefit.SETRANGE("Employee No.","No.");
                // OK := MedicalAidBenefit.FIND('+');
                // IF OK THEN BEGIN
                //REPEAT
                //  MedicalAidBenefit."Number Of Dependants":= "Number Of Dependants";
                //  MedicalAidBenefit.MODIFY;
                //UNTIL MedicalAidBenefit.NEXT = 0;
                // END;
            end;
        }
        field(100; "Medical Scheme Name"; Text[30])
        {
            //TableRelation = "Medical Scheme"."Medical Scheme";

            trigger OnValidate()
            begin
                //MedicalAidBenefit.SETRANGE("Employee No.","No.");
                //OK := MedicalAidBenefit.FIND('+');
                //IF OK THEN BEGIN
                // REPEAT
                // MedicalAidBenefit."Medical Aid Name":= "Medical Aid Name";
                //  MedicalAidBenefit.MODIFY;
                // UNTIL MedicalAidBenefit.NEXT = 0;
                // END;
            end;
        }
        field(101; "Amount Paid By Employee"; Decimal)
        {

            trigger OnValidate()
            begin
                //  MedicalAidBenefit.SETRANGE("Employee No.","No.");
                //  OK := MedicalAidBenefit.FIND('+');
                //   IF OK THEN BEGIN
                //     REPEAT
                //      MedicalAidBenefit."Amount Paid By Employee":= "Amount Paid By Employee";
                //       MedicalAidBenefit.MODIFY;
                //     UNTIL MedicalAidBenefit.NEXT = 0;
                //    END;
            end;
        }
        field(102; "Amount Paid By Company"; Decimal)
        {

            trigger OnValidate()
            begin
                //  MedicalAidBenefit.SETRANGE("Employee No.","No.");
                //   OK := MedicalAidBenefit.FIND('+');
                //  IF OK THEN BEGIN
                // REPEAT
                //      MedicalAidBenefit."Amount Paid By Company":= "Amount Paid By Company";
                //      MedicalAidBenefit.MODIFY;
                // UNTIL MedicalAidBenefit.NEXT = 0;
                //   END;
            end;
        }
        field(103; "Receiving Car Allowance ?"; Boolean) { }
        field(104; "Second Language (R/W/S)"; Code[20])
        {
            //TableRelation = "HR Language Preference".Code;
        }
        field(105; "Additional Language"; Code[20])
        {
            //TableRelation = "HR Language Preference".Code;
        }
        field(106; "Cell Phone Reimbursement?"; Boolean) { }
        field(107; "Amount Reimbursed"; Decimal) { }
        field(108; "UIF Country"; Code[20])
        {
            //TableRelation = "Country/Region".Code;
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
            OptionMembers = " ",Resignation,"Non-Renewal Of Contract",Dismissal,Retirement,Deceased,Termination,"Contract Ended",Abscondment,"Appt. Revoked","Contract Termination",Retrenchment,Other;


            //**Added by ACR 12/08/2002
            //**Block resource if Terminated




        }
        field(113; "Job Specification"; Code[30]) { }
        field(114; DateOfBirth; Date) { }
        field(115; DateEngaged; Date) { }
        field(116; "Postal Address2"; Text[30]) { }
        field(117; "Postal Address3"; Text[20]) { }
        field(118; "Residential Address2"; Text[30]) { }
        field(119; "Residential Address3"; Text[20]) { }
        field(120; "Post Code2"; Code[20])
        {
            //TableRelation = "Post Code";
        }
        field(121; Citizenship; Code[20])
        {
            //TableRelation = "Country/Region".Code;
        }
        field(122; "Name Of Manager"; Text[30]) { }
        field(123; "User ID"; Code[20])
        {
            //TableRelation = User."User ID";
            //This property is currently not supported
            //Test//TableRelation = true;


        }
        field(124; "Disabling Details"; Text[30]) { }
        field(125; "Disability Grade"; Text[30]) { }
        field(126; "Passport Number"; Text[30]) { }
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
        field(131; Region; Code[10])
        {
            //TableRelation = "Dimension Value".Code where ("Dimension Code"=const('REGION'));
        }
        field(132; "Manager Emp No"; Code[30]) { }
        field(133; Temp; Text[20]) { }
        field(134; "Employee Qty"; Integer)
        {
            //CalcFormula = count("HR Employee C");
            FieldClass = FlowField;
        }
        field(135; "Employee Act. Qty"; Integer)
        {
            //CalcFormula = count("HR Employee C" where ("Termination Category"=filter(=" ")));
            FieldClass = FlowField;
        }
        field(136; "Employee Arc. Qty"; Integer)
        {
            //CalcFormula = count("HR Employee C" where ("Termination Category"=filter(<>" ")));
            FieldClass = FlowField;
        }
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
        field(144; "Custom Grading"; Code[20])
        {
            //TableRelation = "HR Custom Grading"."Custom Grading";
        }
        field(145; "PIN Number"; Code[20]) { }
        field(146; "Pension No."; Code[20]) { }
        field(147; "NHIF No."; Code[20]) { }
        field(148; "Cause of Inactivity Code"; Code[20])
        {
            Caption = 'Cause of Inactivity Code';
            //TableRelation = "Cause of Inactivity";
        }
        field(149; "Grounds for Term. Code"; Code[10])
        {
            Caption = 'Grounds for Term. Code';
            //TableRelation = "Grounds for Termination";
        }
        field(150; "PAYROLL NO"; Code[10]) { }

        field(152; "HELB No"; Text[10]) { }
        field(153; "Co-Operative No"; Text[10]) { }
        field(154; "Wedding Anniversary"; Date) { }
        field(155; Grade; Code[20])
        {
            FieldClass = Normal;
            //TableRelation = Grades.Grade;
        }
        field(156; "Competency Area"; Code[20])
        {
            FieldClass = FlowFilter;
            //TableRelation = "Competency Areas".Code where ("Employee No"=field("No."),

        }
        field(157; "Cost Center Code"; Code[20])
        {
            //TableRelation = "Dimension Value".Code where ("Dimension Code"=const('COURSE'));
        }
        field(158; "Position To Succeed"; Code[20])
        {
            //TableRelation = "Company Jobs"."Job ID";

            trigger OnValidate()
            begin
                /*SuccessionGap.RESET;
                SuccessionGap.SETRANGE(SuccessionGap."Employee No","No.");
                IF SuccessionGap.FIND('-') THEN
                SuccessionGap.DELETEALL;
                
                JobReq.RESET;
                JobReq.SETRANGE(JobReq."Job Id","Position To Succeed");
                IF JobReq.FIND('-') THEN
                BEGIN
                REPEAT
                IF NOT EmpQualification.GET("No.",JobReq."Qualification Code") THEN
                BEGIN
                SuccessionGap.INIT;
                SuccessionGap."Employee No":="No.";
                SuccessionGap."Job Id":=JobReq."Job Id";
                SuccessionGap."Qualification Type":=JobReq."Qualification Type";
                SuccessionGap."Qualification Code":=JobReq."Qualification Code";
                SuccessionGap.Qualification:=JobReq.Qualification;
                SuccessionGap.Priority:=JobReq.Priority;
                SuccessionGap.INSERT;
                END;
                UNTIL JobReq.NEXT = 0;
                END;
                 */

            end;
        }
        field(159; "Succesion Date"; Date) { }
        field(160; "Send Alert to"; Code[20])
        {
            //TableRelation = "HR Employee C"."No.";
        }
        field(161; Tribe; Code[20])
        {
            //TableRelation = "Language".Code;
        }
        field(162; Religion; Code[20])
        {
            //TableRelation = Religion.Relegion;
        }
        field(163; "Job Title"; Text[50]) { }
        field(164; "Post Office No"; Text[10]) { }
        field(165; "Posting Group"; Code[10])
        {
            NotBlank = true;
            //TableRelation = "HR Posting Groups"."Posting Group";
        }
        field(166; "Payroll Posting Group"; Code[10])
        {
            //TableRelation = "prEmployee Posting Group".Code;
        }
        field(167; "Served Notice Period"; Boolean) { }
        field(168; "Exit Interview Date"; Date) { }
        field(169; "Exit Interview Done by"; Code[20])
        {
            //TableRelation = "HR Employee C"."No.";
        }
        field(170; "Allow Re-Employment In Future"; Boolean) { }
        field(171; "Medical Scheme Name #2"; Text[20])
        {
            //TableRelation = "Medical Scheme"."Medical Scheme";

            trigger OnValidate()
            begin
                //MedicalAidBenefit.SETRANGE("Employee No.","No.");
                //OK := MedicalAidBenefit.FIND('+');
                //IF OK THEN BEGIN
                // REPEAT
                // MedicalAidBenefit."Medical Aid Name":= "Medical Aid Name";
                //  MedicalAidBenefit.MODIFY;
                // UNTIL MedicalAidBenefit.NEXT = 0;
                // END;
            end;
        }
        field(172; "Resignation Date"; Date) { }
        field(173; "Suspension Date"; Date) { }
        field(174; "Demised Date"; Date) { }
        field(175; "Retirement date"; Date) { }
        field(176; "Retrenchment date"; Date) { }
        field(177; Campus; Code[20])
        {
            //TableRelation = "Dimension Value".Code where ("Dimension Code"=const('CAMPUS'));
        }
        field(178; Permanent; Boolean) { }
        field(179; "Library Category"; Option)
        {
            OptionMembers = "ADMIN STAFF","TEACHING STAFF",DIRECTORS;
        }
        field(180; Category; Code[20]) { }
        field(181; "Payroll Departments"; Code[20])
        {
            //TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(3));


        }
        field(182; "Library Code"; Code[20])
        {
            //TableRelation = "Library HR Codes"."Lib Code";
        }
        field(183; "Library Borrower Type"; Option)
        {
            OptionCaption = 'Staff';
            OptionMembers = Staff;
        }
        field(184; Names; Text[50]) { }
        field(185; Lecturer; Boolean) { }
        field(186; "Maximun Hours"; Decimal) { }
        field(187; Password; Text[50]) { }
        field(188; "count"; Integer)
        {
            //CalcFormula = count("HR Employee C" where ("No."=field("No.")));
            FieldClass = FlowField;
        }
        field(189; "Portal Password"; Text[20])
        {

            trigger OnValidate()
            begin
                "Changed Password" := false;
                Modify;
            end;
        }
        field(190; "Changed Password"; Boolean) { }
        field(191; Active; Boolean) { }
        field(192; "Employee Type"; Option)
        {
            OptionCaption = ' ,Permanent,Casual,Part Time';
            OptionMembers = " ",Permanent,Casual,"Part Time";
        }
        field(193; "Legnth of Contract"; Text[10]) { }
        field(2000; "Leave Balance"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        field(2001; "Global Dimension 2"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            //TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(2002; "Social Security No."; Code[10]) { }
        field(2003; "Total Leave Taken"; Decimal)
        {
            //CalcFormula = sum("HR Leave Ledg Entries2"."No. of days" where ("Staff No."=field("No."),
            //  "Leave Entry Type"=filter(Negative),
            //  "Leave Type"=field("Leave Type Filter")));
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;
        }
        field(2006; "Total (Leave Days)"; Decimal)
        {
            //CalcFormula = sum("HR Leave Ledg Entries2"."No. of days" where ("Staff No."=field("No."),
            //    "Leave Entry Type"=const(Positive)));
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
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                Validate("Allocated Leave Days");
            end;
        }
        field(2009; "Cash per Leave Day"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(2023; "Allocated Leave Days"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total (Leave Days)" := "Allocated Leave Days" + "Reimbursed Leave Days";
                //SUM UP LEAVE LEDGER ENTRIES
                CalcFields("Total Leave Taken");
                "Leave Balance" := "Total (Leave Days)" - "Total Leave Taken";
                //TotalDaysVal := Rec."Total Leave Taken";
            end;
        }
        field(2024; "End of Contract Date"; Date) { }
        field(2025; "Main Bank"; Code[10])
        {
            //TableRelation = "prBank Structure"."Bank Code";

            trigger OnValidate()
            begin
                // PrBankStructure.SETRANGE(PrBankStructure."Bank Code","Main Bank");
                //  IF  PrBankStructure.FIND('-') THEN
                // "Branch Bank":=PrBankStructure."Branch Code";
            end;
        }
        field(2026; "Branch Bank"; Code[10])
        {
            //TableRelation = "prBank Structure"."Branch Code";

            trigger OnValidate()
            begin
                //   PrBankStructure.SETRANGE(PrBankStructure."Branch Code","Branch Bank");
                //   IF  PrBankStructure.FIND('-') THEN
                //   "Main Bank":=PrBankStructure."Bank Code";
            end;
        }
        field(2028; "Alt. Address Start Date"; Date)
        {
            Caption = 'Alt. Address Start Date';
        }
        field(2029; "Alt. Address End Date"; Date)
        {
            Caption = 'Alt. Address End Date';
        }
        field(2030; "Alt. Address Code"; Code[10])
        {
            Caption = 'Alt. Address Code';
            //TableRelation = "Alternative Address".Code where ("Employee No."=field("No."));
        }
        field(2034; "Bank Account Number"; Code[15]) { }
        field(2035; "Total Absence (Base)"; Decimal)
        {
            //CalcFormula = sum("Employee Absence"."Quantity (Base)" where ("Employee No."=field("No."),
            //"Cause of Absence Code"=field("Cause of Absence Filter"),
            //  "From Date"=field("Date Filter")));
            Caption = 'Total Absence (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(2036; "Cause of Absence Filter"; Code[10])
        {
            Caption = 'Cause of Absence Filter';
            FieldClass = FlowFilter;
            //TableRelation = "Cause of Absence";
        }
        field(2037; "Leave Status"; Option)
        {
            OptionMembers = "On Leave"," Resumed";
        }
        field(2038; "Leave Type Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            //TableRelation = "Leave Types".Code;
        }
        field(50000; UserID; Code[10]) { }
        field(50001; "HR Department Name"; Text[70]) { }
        field(50002; Region1; Text[10]) { }
        field(50003; "Is Driver"; Boolean) { }
        field(50004; "Is Administrator"; Boolean) { }
        field(50005; "CCentre Name"; Text[10]) { }
        field(50006; "Leave Date Filter"; Text[10]) { }
        field(50007; TotalLeaveTaken; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(50008; "Reason for Joining"; Text[10]) { }
        field(50009; "Reason for Leaving"; Text[10]) { }
        field(50010; "Loan Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            //TableRelation = Employee."Address 2";
        }
        field(50011; CurrentYearFilter; Date)
        {
            Description = 'To filter the leave days as per the year';
            FieldClass = FlowFilter;
        }
        field(50012; "New Bal B/F"; Decimal) { }
        field(50013; "New Balance"; Decimal) { }
        field(50014; "New Earned"; Decimal) { }
        field(50015; "Leave Bal Val"; Decimal) { }
        field(50016; "Total Leave Earned"; Decimal)
        {
            //CalcFormula = sum("Assignment Matrix M".Amount where ("Employee No"=field("No."),
            //Code=filter(E006)));
            FieldClass = FlowField;
        }
        field(50017; "Staff Special Imprest Account"; Code[20])
        {
            //TableRelation = Customer;
        }
        field(50018; "Staff Other Staff Debt Account"; Code[20])
        {
            //TableRelation = Customer;
        }
        field(50019; "Transport Allowance"; Decimal) { }
        field(50020; "Last Date of Promotion"; Date) { }
        field(50021; "Retirement Yrs"; Decimal) { }
        field(50022; "Check 1"; Boolean) { }
        field(50023; "Check 2"; Boolean) { }
        field(50024; "Check 3"; Boolean) { }
        field(50025; "Check 4"; Boolean) { }
        field(50026; "Check 5"; Boolean) { }
        field(50027; "Check 6"; Boolean) { }
        field(50028; "Check 7"; Boolean) { }
        field(50029; "Check 8"; Boolean) { }
        field(50030; "Check 9"; Boolean) { }
        field(50031; "Check 10"; Boolean) { }
        field(50032; Check11; Boolean) { }
        field(50033; "Check 12"; Boolean) { }
        field(50034; "Leave Allowance"; Decimal) { }
        field(50035; "Leave Taken Adjusted"; Decimal) { }
        field(50043; "Leave CateSgory"; Option)
        {
            NotBlank = false;
            OptionCaption = 'Normal,Managerial';
            OptionMembers = Normal,Managerial;
        }
        field(50044; "Earned Leave Days"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(50048; "Cost Center Units"; Boolean) { }
        field(50049; "Lock Bank Details"; Boolean) { }
        field(50050; test; Code[10]) { }
        field(50051; "HR Department"; Code[10])
        {
            //TableRelation = "Dimension Value".Code where ("Dimension Code"=filter('DEPARTMENT'));


        }
        field(50054; "Notice Send Date"; Date) { }
        field(50055; "Notice Send"; Boolean) { }
        field(50056; "Application No"; Code[10]) { }
        field(50057; "Dimension 3"; Code[10])
        {
            CaptionClass = '1,2,3';
            //TableRelation = "Dimension Value".Code where ("Dimension Code"=filter('BRANCH'));
        }
        field(50058; "Dimension 4"; Code[10])
        {
            CaptionClass = '1,2,4';
            //TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(4));
        }
        field(50059; "Dimension 5"; Code[10])
        {
            CaptionClass = '1,2,5';
            //TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(5));
        }
        field(50060; "Dimension 6"; Code[10])
        {
            CaptionClass = '1,2,6';
            //TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(6));
        }
        field(50061; "Dimension 7"; Code[10])
        {
            CaptionClass = '1,2,7';
            //TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(7));
        }
        field(50062; "Dimension 8"; Code[10])
        {
            CaptionClass = '1,2,8';
            //TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(8));
        }
        field(50063; "Dimension 2"; Code[10])
        {
            CaptionClass = '1,2,4';
            //TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(50064; Approver; Boolean) { }
        field(50065; "Alert Date"; Date) { }
        field(50066; EverLogged; Boolean) { }
        field(50067; "Disable Portal"; Boolean) { }
        field(50068; MD; Boolean) { }
        field(50069; TotalDaysVal; Decimal) { }
        field(50070; "Actual Job ID"; Code[10])
        {
            //TableRelation = "HR Job Matrix Entry"."Act Job ID" where ("Job ID"=field(Position));


        }
        field(50071; "Activate Terminated"; Boolean) { }
        field(50072; Step; Code[10])
        {
            //TableRelation = "HR Job Category/Grade".Code where (Type=filter(Step));
        }
        field(50073; "Other Language"; Text[10]) { }
        field(50074; "Calculation Scheme"; Code[10])
        {
            //TableRelation = Table132226.Field1048577;
        }
        field(50075; "TALGWU No."; Code[10]) { }
        field(50076; "Mode of Payments"; Option)
        {
            OptionMembers = Cash,Cheque,Bank;
        }
        field(50077; "PPF No."; Code[10]) { }
        field(50078; "PSPF No"; Code[10]) { }
        field(50079; "LAPF No."; Code[10]) { }
        field(50080; "Staff Salary Advance Account"; Code[20])
        {
            //TableRelation = Customer;
        }
        field(50081; "Staff Loan Account"; Code[20])
        {
            //TableRelation = Customer;
        }
        field(50082; "Grade Step"; Code[10]) { }
        field(50083; Scale; Code[10])
        {
            //TableRelation = "Setup Parameters".Code where (Type=const("Salary Scale"));


        }
        field(50084; "Basic Pay"; Decimal) { }
        field(50085; "Staff Safari Imprest Account"; Code[20])
        {
            //TableRelation = Customer;
        }
        field(50086; "Bank Code"; Code[10])
        {
            //TableRelation = Employee;
        }
        field(50087; "Bank Code 2"; Code[10])
        {
            //TableRelation = Employee;
        }
        field(50088; "Bank Account No 2"; Code[10]) { }
        field(50089; "Bank Code 3"; Code[10])
        {
            //TableRelation = Employee;
        }
        field(50090; "Bank Account No 3"; Code[10]) { }
        field(50091; "Bank Code 4"; Code[10])
        {
            //TableRelation = Employee;
        }
        field(50092; "Bank Account No 4"; Code[10]) { }
        field(50093; "Bank Account 2 (Net Amount)"; Decimal) { }
        field(50094; "Bank Account 3 (Net Amount)"; Decimal) { }
        field(50095; "Bank Account 4 (Net Amount)"; Decimal) { }
        field(50098; "Confirmation Date"; Date) { }
        field(50099; "Confirmation Status"; Option)
        {
            OptionMembers = "Not Confirmed",Confirmed;
        }
        field(50100; "Appointment Date"; Date) { }
        field(50101; Succeed; Text[10]) { }
        field(50102; "Clearance Status"; Option)
        {
            OptionCaption = 'HOD Clearance,FM Clearance,ICT Clearance,HR Clearance,Done Cleared';
            OptionMembers = "HOD Clearance","FM Clearance","ICT Clearance","HR Clearance";
        }
        field(50103; Users; Boolean) { }
        field(50104; "Total Active Permanent"; Integer)
        {
            //CalcFormula = count("HR Employee C" where ("Employee Type"=filter(Permanent),
            //Status=filter(Normal)));
            FieldClass = FlowField;
        }
        field(50105; "Total Active Casuals"; Integer)
        {
            //CalcFormula = count("HR Employee C" where ("Employee Type"=filter(Casual),
            //  Status=filter(Normal)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "First Name") { }
        key(Key3; "Last Name") { }
        key(Key4; "ID Number") { }
        key(Key5; "User ID") { }
        key(Key6; "Cost Code") { }
        key(Key7; "Date Of Join", "Date Of Leaving") { }
        key(Key8; "Termination Category") { }
        key(Key9; "Known As") { }
    }

    fieldgroups { }



    //MedicalAidBenefit.SETRANGE("Employee No.","No.");
    //MedicalAidBenefit.DELETEALL;

    //PensionBenefit.SETRANGE("Employee No.","No.");
    //PensionBenefit.DELETEALL;

    //CarBenefit.SETRANGE("Employee No.","No.");
    //CarBenefit.DELETEALL;




    trigger OnInsert()
    begin




        //CurrentPayDetails;
    end;



    procedure FullName(): Text[100]
    begin
        if "Middle Name" = '' then
            exit("Known As" + ' ' + "Last Name")
        else
            exit("Known As" + ' ' + "Middle Name" + ' ' + "Last Name");
    end;




}

