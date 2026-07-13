Table 50558 "HR Staff Requisition"
{

    fields
    {
        field(1; "No."; Code[20]) { }
        field(2; Date; Date) { }
        field(3; "Employee No"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                if Emp.Get("Employee No") then begin
                    Emp.CalcFields(Emp."Leave Balance");
                    "Employee Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";

                end;
            end;
        }
        field(4; "Employee Name"; Text[100]) { }
        field(5; "Campus Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(6; "Department Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(7; "Applied Days"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                CalcFields("Availlable Days");
                if (("Availlable Days" = 0) or ("Applied Days" > "Availlable Days")) then begin
                    Error('Applied days must not be more than leave balance.');
                end;
                if ("Applied Days" <> 0) and ("Starting Date" <> 0D) then begin
                    // "End Date":=CalcEndDate("Starting Date","Applied Days");
                    // "Return Date" :=CalcReturnDate("End Date");
                    Validate("Starting Date")
                end;
            end;
        }
        field(8; "Starting Date"; Date) { }
        field(9; "End Date"; Date) { }
        field(10; Purpose; Text[200]) { }
        field(11; "Leave Type"; Code[20])
        {
            TableRelation = "Leave Types".Code;

            trigger OnValidate()
            begin
                CalcFields("Availlable Days");
                if Emp.Get("Employee No") then begin
                    Emp.CalcFields(Emp."Leave Balance");
                    "Leave Balance" := Emp."Leave Balance";
                end;
            end;
        }
        field(12; "Leave Balance"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(13; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(14; Status; Option)
        {
            OptionCaption = 'Open,Released,Pending Approval,Approved,Cancelled,Posted';
            OptionMembers = Open,Released,"Pending Approval",Approved,Cancelled,Posted;

            trigger OnValidate()
            begin
                /*
                  IF Status = Status::Posted THEN BEGIN
                 leaveLedgers.RESET;
                 IF leaveLedgers.FIND('+') THEN
                 lastNo:=leaveLedgers."Entry No."+10
                 ELSE lastNo:=10;
                  // post the leave application to ledger entries with a negative adjustment
                  leaveLedgers.INIT;
                   leaveLedgers."Entry No.":=lastNo;
                   leaveLedgers."Employee No":="Employee No";
                   leaveLedgers."Document No":="No.";
                   leaveLedgers."Leave Type":="Leave Type";
                   leaveLedgers."Transaction Date":=TODAY;
                   leaveLedgers."Transaction Type":=leaveLedgers."Transaction Type"::Application;
                   leaveLedgers."No. of Days":=(("Applied Days")*(-1));
                   leaveLedgers."Transaction Description":='Leave Application';
                   leaveLedgers."Leave Period":=DATE2DWY(TODAY,3);
                  leaveLedgers.INSERT;
                  "Leave Balance":="Availlable Days";
                  MODIFY
                 END;
                 */

            end;
        }
        field(15; "User ID"; Code[30]) { }
        field(16; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR".Code;

            trigger OnValidate()
            begin

                TestField(Status, Status::Open);
                /*
                if not UserMgt.CheckRespCenter(1, "Responsibility Center") then
                    Error(
                      Text001,
                      RespCenter.TableCaption, UserMgt.GetPurchasesFilter);
               
               "Location Code" := UserMgt.GetLocation(1,'',"Responsibility Center");
               IF "Location Code" = '' THEN BEGIN
                 IF InvtSetup.GET THEN
                   "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
               END ELSE BEGIN
                 IF Location.GET("Location Code") THEN;
                 "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
               END;

               UpdateShipToAddress;
                  */
                /*
             CreateDim(
               DATABASE::"Responsibility Center","Responsibility Center",
               DATABASE::Vendor,"Pay-to Vendor No.",
               DATABASE::"Salesperson/Purchaser","Purchaser Code",
               DATABASE::Campaign,"Campaign No.");

             IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
               RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
               "Assigned User ID" := '';
             END;
               */

            end;
        }
        field(17; Posted; Boolean) { }
        field(18; "Posted By"; Code[20]) { }
        field(19; "Posting Date"; Date) { }
        field(20; "Process Leave Allowance"; Boolean) { }
        field(21; "Availlable Days"; Decimal)
        {
            CalcFormula = sum("HR Leave Ledger"."No. of Days" where("Employee No" = field("Employee No")));
            DecimalPlaces = 0 : 0;
            FieldClass = FlowField;
        }
        field(22; "Return Date"; Date) { }
        field(23; "Reliever No."; Code[30])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                if Emp3.Get("Reliever No.") then
                    "Reliever Name" := Emp3."First Name" + ' ' + Emp3."Middle Name" + ' ' + Emp3."Last Name";
            end;
        }
        field(24; "Reliever Name"; Text[250]) { }
        field(25; RequisitionType; Option)
        {
            OptionCaption = 'Academic Requisition,Medical Claims/General Claims,Tuition waiver,Leave Extension Requisition, Staff Update';
            OptionMembers = "Academic Requisition","Medical Claims/General Claims","Tuition waiver","Leave Extension Requisition"," Staff Update";
        }
        field(26; "Name of Beneficiary"; Text[30]) { }
        field(27; "Beneficiary Reg. No"; Code[50]) { }
        field(28; "Beneficary Relationship"; Code[10]) { }
        field(29; "Beneficiary Date of Birth"; Date) { }
        field(30; "Name of Programme"; Code[20]) { }
        field(31; "School Code"; Code[20]) { }
        field(32; "Duration of Study"; Code[10]) { }
        field(33; "Current Year/Semester of Study"; Code[30]) { }
        field(34; "Campus offering Programme"; Code[30]) { }
        field(35; "Total Tuition Kshs"; Decimal) { }
        field(36; "Amount of waiver applied Kshs"; Decimal) { }
        field(37; "First Name"; Text[80])
        {

            trigger OnValidate()
            begin
                //fnTrackChanges('Change in First name',FORMAT(xRec."First Name"),FORMAT("First Name"));
            end;
        }
        field(38; "Middle Name"; Text[50])
        {

            trigger OnValidate()
            begin
                //fnTrackChanges('Change in Middle name',FORMAT(xRec."Middle Name"),FORMAT("Middle Name"));
            end;
        }
        field(39; "Last Name"; Text[50])
        {

            trigger OnValidate()
            begin
                //fnTrackChanges('Change in Last name',FORMAT(xRec."Last Name"),FORMAT("Last Name"));
            end;
        }
        field(40; "Postal Address"; Text[80]) { }
        field(41; "Residential Address"; Text[80]) { }
        field(42; City; Text[30]) { }
        field(43; "Post Code"; Code[20])
        {
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(44; Region; Text[30]) { }
        field(45; "Home Phone Number"; Text[30]) { }
        field(46; "Cellular Phone Number"; Text[30]) { }
        field(47; "Work Phone Number"; Text[30]) { }
        field(48; "E-Mail"; Text[80]) { }
        field(49; Title; Option)
        {
            OptionMembers = "MR.","MRS.","MISS.",MS,"DR."," ENG. ",DR,CC,"PROF.",PROF;
        }
        field(50; "Marital Status"; Option)
        {
            OptionCaption = ' ,Single,Married,Separated,Divorced,Widow(er),Other';
            OptionMembers = " ",Single,Married,Separated,Divorced,"Widow(er)",Other;
        }
        field(51; Tribe; Code[20]) { }
        field(52; Religion; Code[20]) { }
        field(53; "Satisfaction Level"; Option)
        {
            OptionCaption = 'Very satisfying,Fairly satisfying,Unsatisfying,No comment';
            OptionMembers = "Very satisfying","Fairly satisfying",Unsatisfying,"No comment";
        }
        field(54; Motivation; Option)
        {
            OptionCaption = 'Yes,No';
            OptionMembers = Yes,No;
        }
        field(55; "Reason Motivated/Unmotivated"; Text[30]) { }
        field(56; "Reasons For Leaving"; Code[10]) { }
        field(57; "Suggest Enhancement Motivation"; Text[30]) { }
        field(58; "Recommend Somebody?"; Option)
        {
            OptionCaption = 'Yes,No';
            OptionMembers = Yes,No;
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

    var
        Emp3: Record "HR-Employee";
        Emp: Record "HR-Employee";
}

