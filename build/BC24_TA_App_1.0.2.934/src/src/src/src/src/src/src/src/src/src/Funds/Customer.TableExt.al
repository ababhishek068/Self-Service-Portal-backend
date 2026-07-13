TableExtension 50014 Customer extends Customer
{

    //Unsupported feature: Property Modification (Permissions) on "Customer(Table 18)".

    LookupPageID = "Customer List";

    fields
    {

        modify("Customer Posting Group")
        {
            trigger OnBeforeValidate()
            begin
                TestNoEntriesExist(FIELDCAPTION("Customer Posting Group"));
            end;
        }

        field(50040; "Added to remove error"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50050; "Balance (Cafe)"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Balance';
            Editable = false;
            FieldClass = Normal;
        }
        field(50051; "Debit Amount (Cafe)"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';
            Editable = false;
            FieldClass = Normal;
        }
        field(50052; "Credit Amount (Cafe)"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';
            Editable = false;
            FieldClass = Normal;
        }
        field(63000; Gender; Option)
        {
            OptionMembers = " ",Male,Female;
        }
        field(63292; "Current Programme"; code[20])
        {
            TableRelation = Programme;
        }
        field(63293; "Class Code"; code[20])
        {
            TableRelation = "Course Classes".Code;
        }

        field(99000; MK; Boolean) { }
        field(50344; "Hostel Allocated"; Boolean) { }
        field(50345; "Billed Hostel"; Boolean) { }
        field(50346; "Hostel No."; code[20]) { }
        field(50347; "Room Code"; code[20]) { }
        field(50348; "Space Booked"; code[20]) { }

        field(99901; "MK Option DT"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Active","In active";
        }
        field(63001; "Date Of Birth"; Date) { }
        field(63002; Age; Decimal) { }
        field(63003; "Marital Status"; Option)
        {
            OptionMembers = Single,Married,Divorced,Deceased;
        }
        field(63004; "Blood Group"; text[50]) { }
        field(63005; Weight; Decimal) { }
        field(63006; Height; Decimal) { }
        field(63007; Religion; Code[30])
        {
            Caption = 'Religion';
            // TableRelation = Religions;
        }
        field(63008; Citizenship; text[50]) { }
        field(63009; "Payments By"; Code[20])
        {
            //   TableRelation = "Payment By".Code;
        }

        field(63011; "ID No"; Code[30])
        {

            trigger OnValidate()
            begin
                Cust.Reset;
                Cust.SetRange(Cust."ID No", "ID No");
                if Cust.Find('-') then
                    Message('Please note that the ID Numer ' + "ID No" + ' already exists');
            end;
        }

        field(63012; "Date Registered"; Date) { }
        field(63013; "Membership No"; text[50]) { }
        field(63014; "Customer Type"; Option)
        {
            OptionCaption = 'Customer,Student,Hotel,Pump Attendance';
            OptionMembers = Customer,Student,Hotel,"Pump Attendance";
        }
        field(63015; "Birth Cert"; Code[30])
        {

            trigger OnValidate()
            begin
                Cust.Reset;
                Cust.SetRange(Cust."Birth Cert", "Birth Cert");
                if Cust.Find('-') then
                    Error('Birth Cert/KNEC No. exists.');
            end;
        }
        field(63016; "UNISA No"; Code[30]) { }

        field(63019; "Name 3"; Text[50]) { }
        field(63020; Status; Option)
        {
            OptionCaption = 'Registration,Current,Alluminae,Dropped Out,Deffered,Suspended,Expelled,Discontinued,Withdrawn,Deceased,Transferred,Academic Leave,Completed';
            OptionMembers = Registration,Current,Alluminae,"Dropped Out",Deffered,Suspended,Expelled,Discontinued,Withdrawn,Deceased,Transferred,"Academic Leave",Completed;

            trigger OnValidate()
            begin
                "Status Change Date" := Today;
            end;
        }

        field(63022; "Library Code"; Code[20]) { }
        field(63024; "KNEC No"; Code[30]) { }
        field(63025; "Passport No"; Code[30]) { }


        field(63034; "Post to Biometric"; Boolean)
        {

            trigger OnValidate()
            begin
                "User ID" := UserId;
            end;
        }
        field(63035; "User ID"; Code[20]) { }




        field(63042; "No Of Reversals"; Integer)
        {
            CalcFormula = count("Cust. Ledger Entry" where("Customer No." = field("No."),
                                                            Reversed = const(true)));
            FieldClass = FlowField;
        }
        field(63043; "Document No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Cust. Ledger Entry"."Document No.";
        }

        field(63047; "Staff No."; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
                Emp: Record "HR-Employee";
            begin
                if Emp.get("Staff No.") then
                    "Employee Job Group" := emp."Job Group";
            end;
        }


        field(63051; "Accredited Centre no."; Code[20]) { }

        field(63058; "Group/Company"; Code[30]) { }
        field(63059; "Departure Date"; Date) { }
        field(63060; "Arrival Date"; Date) { }
        field(63061; Nationality; text[50])
        {
            InitValue = 'KENYAN';

        }
        field(63164; "Disabled"; boolean) { }
        field(63264; "Disability Details"; text[200]) { }
        field(63064; "Barcode No"; Code[20]) { }
        field(63069; Remarks; Text[50]) { }
        field(63070; "Guest Agent Code"; Code[20]) { }
        field(63078; "Check Out Date"; Date) { }
        field(63079; "Check In Time"; Time) { }
        field(63080; "HTL Status"; Option)
        {
            OptionMembers = ,,Reserved,Current,Old;
        }
        field(63081; "HELB No."; Code[50]) { }
        field(63082; "Deferement Period"; DateFormula) { }
        field(63083; "Status Change Date"; Date) { }

        field(63085; Password; text[50])
        {
            Editable = true;
        }

        field(63089; "Date Issued"; Date) { }

        field(63092; "Certificate Status"; Option)
        {
            OptionCaption = ' ,Pending,Collected';
            OptionMembers = " ",Pending,Collected;

            trigger OnValidate()
            begin
                if "Certificate Status" = "certificate status"::Collected then
                    "Date Collected" := Today;
            end;
        }
        field(63093; "Date Collected"; Date) { }
        field(63094; Confirmed; Boolean) { }
        field(63095; "Confirmed Remarks"; Text[50]) { }

        field(63099; "No Of Creidts"; Integer)
        {
            CalcFormula = count("Detailed Cust. Ledg. Entry" where("Customer No." = field("No."),
                                                                    "Entry Type" = const("Initial Entry"),
                                                                    "Credit Amount (LCY)" = filter(> 0)));
            FieldClass = FlowField;
        }




        field(63113; "Hostel Black Listed"; Boolean) { }
        field(63114; "Black Listed Reason"; Text[80]) { }
        field(63115; "Black Listed By"; Code[20]) { }
        field(63116; "Audit Issue"; Boolean) { }
        field(63117; "Not Billed"; Boolean) { }
        field(63118; "New Stud"; Boolean) { }
        field(63119; "Programme Category Filter"; Option)
        {
            FieldClass = FlowFilter;
            OptionCaption = ',Diploma,Undergraduate,Postgraduate,Course List';
            OptionMembers = ,Diploma,Undergraduate,Postgraduate,"Course List";
        }
        field(63120; sms_Password; text[50]) { }
        field(63121; "BroadCast Filter"; Code[20])
        {
            FieldClass = FlowFilter;

        }
        field(63194; "Cash Customer"; Boolean) { }
        field(63921; "Outstanding Imprest"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Imprest Header" where("Account No." = field("No."), Posted = filter(true)));

        }
        field(63922; "Accounted Imprest"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Imprest Surrender Header" where("Account No." = field("No."), Posted = filter(true)));

        }

        field(63127; "Lock Online Application"; Boolean) { }
        field(63128; "PIN No"; Code[20]) { }
        field(63129; "Allow Reg. With Balance"; Boolean) { }
        field(63130; "Allowed Reg. By"; Code[20]) { }
        field(63131; "Allowed Date"; Date) { }

        field(63133; "Current Semester"; Code[20]) { }
        field(63134; "ID Card Expiry Year"; Integer) { }
        field(63135; Tribe; Code[20])
        {
            // TableRelation = "HR Hiring Criteria"."Application Code";
        }
        field(63136; "Barcode Picture"; Blob)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(63137; "Graduation Date"; Date) { }


        field(63140; "Sponsor Name"; Text[80]) { }



        field(63156; "Sponsor Address"; Text[50]) { }
        field(63157; "Sponsor Town"; Text[50]) { }
        field(63158; "Sponsor Phone"; text[50]) { }

        field(63159; "Changed Password"; Boolean) { }

        field(63160; "Catering Amount"; Decimal)
        {
            CalcFormula = sum("Catering Prepayment Ledger".Amount where("Customer No" = field("No."),
                                                                         Date = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(63161; "Clearance Status"; Option)
        {
            OptionCaption = 'open,Active,Cleared';
            OptionMembers = open,Active,Cleared;
        }
        field(63162; "Clearance Initiated by"; Code[20]) { }
        field(63163; "Clearance Initiated Date"; Date) { }
        field(63364; "Clearance Initiated Time"; Time) { }



        field(63171; "Refund on PV"; Decimal)
        {
            // CalcFormula = sum ("Payment Line"."Net Amount" where("Account No." = field("No."),
            //                                                      Posted = const(False),
            //                                                      "Payment Status" = const(Approved)));
            FieldClass = FlowField;
        }



        field(63180; "Region Code"; Code[20])
        {
            TableRelation = "Academics Central Setups"."Title Code" where(Category = filter(Counties));


        }
        field(39003900; "Account Type"; Enum "Customer Account Type")
        {
            trigger OnValidate()
            begin
                //Prevent Changing once entries exist
                TestNoEntriesExist(FieldCaption("Account Type"));
            end;
        }
        field(39003901; "Employee Job Group"; Code[50])
        {
            TableRelation = "HR-Employee".Grade;
        }
        field(70135514; "Partner Category"; Code[50])
        {
            TableRelation = "Partner Category".Code;
        }
        field(39003902; "Donor Category"; Option)
        {
            OptionCaption = ' ,Intramural,Extramural';
            OptionMembers = " ",Intramural,Extramural;
        }
        field(39003903; "Allow Indirect Cost"; Boolean) { }
        field(39003904; "Dimension Set ID Filter"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            FieldClass = FlowFilter;
            TableRelation = "Dimension Set Entry";
        }
        field(39003905; "Current School"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }


        field(39003912; "Catering Blocked"; Boolean) { }

        field(39003914; "Mother Full Name"; text[50])
        {
            Description = 'Stores the full name of the mother in the database';
        }
        field(39003915; "Father Full Name"; text[50])
        {
            Description = 'Stores the full name of the father in the database';
        }
        field(39003916; "Guardian Full Name"; text[50])
        {
            Description = 'Stores the full name of the guardian in the database';
        }
        field(39003917; "Mother Contacts"; Code[20]) { }
        field(39003918; "Father Contacts"; Code[20]) { }
        field(39003919; "Gurdian Contacts"; Code[60]) { }


        field(39003933; "Trans Count"; Integer)
        {
            CalcFormula = count("Cust. Ledger Entry" where("Customer No." = field("No.")));

            FieldClass = FlowField;
        }

        field(80001; "Investing Company"; Text[50])
        {
            Caption = 'Investing Company';
            DataClassification = ToBeClassified;
        }

        field(80002; "Certificate No."; Code[20])
        {
            Caption = 'Certificate No.';
            DataClassification = ToBeClassified;
        }

        field(80003; "Date of Issue"; Code[20])
        {
            Caption = 'Date of Issue';
            DataClassification = ToBeClassified;
        }

        field(80004; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = ToBeClassified;
        }

        field(80005; "Duration"; integer)
        {
            Caption = 'Duration';
            BlankZero = true;
            DataClassification = ToBeClassified;
        }

        field(80006; "Maturity Amount"; Decimal)
        {
            Caption = 'Maturity Amount';
            BlankZero = true;
            DataClassification = ToBeClassified;
        }
        field(80007; "Customer Category"; code[20])
        {
            TableRelation = "Customer Category";

            DataClassification = ToBeClassified;
        }
        field(50007; "Charge Filter"; code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Charge;


        }
        field(50008; "Entry Intake"; code[20])
        {

            TableRelation = Intake.Code;
        }
        field(50009; "Application No."; code[20])
        {

            TableRelation = "Registration Form"."Serial No";
        }
        field(39003921; "Completed Units"; Decimal)
        {
            CalcFormula = sum("Student Units"."No. Of Units" where("Student No." = field("No."),
                                                              Grade = filter(<> ''), "Grade Exists" = filter(true), Failed = const(false), Programme = field("Enrolled Programmes"), "Re-Taken" = filter(false)));
            FieldClass = FlowField;
        }
        field(50233; "Programme GPA Points"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Student Units"."CF GPA" where("Student No." = field("No."),
                                                              GPA = filter(> 0), Failed = const(false), "Re-Taken" = const(false), Programme = field("Enrolled Programmes")));

        }
        field(50921; "Completed Units Curr Prog"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Student Units"."No. Of Units" where("Student No." = field("No."),
                                                              Grade = filter(<> ''), "Grade Exists" = filter(true), Failed = const(false), Programme = field("Graduating Programme"), "Re-Taken" = filter(false)));

        }
        field(53951; "Total Units"; Decimal)
        {
            CalcFormula = sum("Student Units"."No. Of Units" where("Student No." = field("No."),
                                                              Programme = field("Programme Filter"), Semester = field("Semester Filter")));
            FieldClass = FlowField;
        }
        field(53921; "Attempted Units"; Decimal)
        {
            CalcFormula = sum("Student Units"."No. Of Units" where("Student No." = field("No."),
                                                              Programme = field("Programme Filter"), "Re-Taken" = filter(false)));
            FieldClass = FlowField;
        }
        field(53922; "Programme Filter"; code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Programme.code;
        }
        field(53933; "Semester Filter"; code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Semesters.Code;
        }

        field(53923; "Enrolled Programmes"; code[20])
        {
            FieldClass = Normal;
            TableRelation = Programme.code;
        }
        field(53924; "Graduating Programme"; code[20])
        {
            FieldClass = Normal;
            TableRelation = Programme.code;
        }
        field(50780; "Required Units"; Decimal)
        {
            CalcFormula = sum("Student Units Audit"."No. Of Units" where("Student No." = field("No."), Programme = field("Current Programme")));

            FieldClass = FlowField;
        }
        field(52780; "Programme Required Units"; Integer)
        {
            CalcFormula = sum(Programme."Graduation Units" where(Code = field("Graduating Programme")));

            FieldClass = FlowField;
        }
        field(55922; "Cumm GPA"; Decimal) { }
        field(55924; "Stage Filter"; code[20])
        {
            FieldClass = Flowfilter;
        }
        field(55925; "Intake Filter"; code[20])
        {
            FieldClass = Flowfilter;
        }
        field(55927; "Academic Status"; code[20]) { }

        field(53926; "Can Graduate"; Boolean)
        {
            trigger OnValidate()
            var
                // GradList: Record "Graduation List";
                GradList: Record "Graduating Students";
            begin
                TestField("Graduating Programme");
                CalcFields("Completed Units Curr Prog");
                CalcFields("Programme Required Units");
                //CalcFields("Current School");

                if "Completed Units Curr Prog" < "Programme Required Units" then begin
                    error('Academic requirement has not been meet. Completed Units=' + format("Completed Units Curr Prog") + ' Required Units=' + format("Programme Required Units"));
                end else begin
                    if not GradList.get("No.") then begin
                        GradList.Init;
                        GradList.No := "No.";
                        GradList.Names := Name;
                        GradList.Programme := "Current Programme";

                        // GradList.Option := "Minor Concentration";
                        //GradList.Semester:=
                        // GradList."Current Av" := CurrentAv;
                        // GradList."Cumm Av" := CummAv;
                        // GradList.Award := Award;
                        GradList.School := "Current School";
                        GradList."Total CF Taken" := "Completed Units Curr Prog";
                        // GradList."Required CF" := "Programme Required Units";
                        GradList.Insert;
                    end;
                end;
            end;
        }
        field(55928; "Staff Claims"; Integer)
        {
            TableRelation = "Staff Claims Header";
            FieldClass = FlowField;
            CalcFormula = count("Staff Claims Header" where("Account No." = field("No."), Status = filter('Posted')));
        }

    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on "Blocked(Key)".


        //Unsupported feature: Deletion (KeyCollection) on ""Primary Contact No."(Key)".

        key(Key1; "Date Registered") { }

    }

    trigger OnAfterInsert()
    var
        GenSetup: record "General Set-Up";
        Noseries: Codeunit "No. Series";
    begin
        if "Customer Type" = "Customer Type"::Student then begin
            GenSetup.get;
            GenSetup.TestField("Student Nos.");
            "No." := Noseries.GetNextNo(GenSetup."Student Nos.", today, true);
        end;
    end;

    procedure TestNoEntriesExist(CurrentFieldName: Text[100])
    var
        ItemLedgEntry: Record "Cust. Ledger Entry";
    begin
        //To prevent change of field
        ItemLedgEntry.SetCurrentkey(ItemLedgEntry."Customer No.");
        ItemLedgEntry.SetRange("Customer No.", "No.");
        if ItemLedgEntry.Find('-') then
            Error(
              Text016,
              CurrentFieldName);
    end;

    var
        Cust: Record Customer;

        //StudChangedReg: Record "Student Changed Numbers";
        Text016: label 'You cannot change the contents of the %1 field because this %2 has one or more posted ledger entries.';

}

