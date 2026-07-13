TableExtension 50011 "User Setup Ext" extends "User Setup"
{
    fields
    {


        field(50000; Leave; Boolean) { }
        field(50009; "School Filter"; Code[20])
        {
            CaptionClass = '1,3,3';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(50018; "Post Bank Rec"; Boolean) { }
        field(50023; "Can Stop Reg."; Boolean) { }
        field(50027; "Cash Advance Staff Account"; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(50030; "ReOpen/Release"; Option)
        {
            OptionMembers = " ",ReOpen,Release;
        }
        field(50031; "Location Code"; Code[10])
        {
            TableRelation = Location.Code;
        }
        field(50036; "Approval Title"; Text[50]) { }
        field(50037; "Employee No."; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(50038; UserName; Text[50]) { }
        field(50039; Approvername; Text[30]) { }
        field(50040; Approvermail; Text[30]) { }
        field(50041; "Imprest Account"; Code[50])
        {
            TableRelation = Customer."No." where("Customer Posting Group" = filter('IMPREST'));

            trigger OnValidate()
            begin
                if Staff.Get("Imprest Account") then begin
                    UserName := Staff."First Name" + ' ' + Staff."Middle Name" + ' ' + Staff."Last Name";
                    "E-Mail" := Staff."Company E-Mail";
                    "Global Dimension 1 Code" := Staff."Department Code";
                    "Job Tittle" := Staff."Job Title";
                end
            end;
        }
        field(50042; "Job Tittle"; Text[100]) { }
        field(50043; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter(= 'DEPARTMENT'));
        }
        field(50044; "Campus Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter(= 'CAMPUS'));
        }
        field(50045; Lecturer; Boolean) { }
        field(50100; "Edit Posted Dimensions"; Boolean) { }
        field(50110; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(50111; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(50113; "Grants Administrator"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50112; "Can Print Transcript"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(39003900; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(39003901; "Responsibility Center"; Code[10]) { }
        field(39003902; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(39003903; "Unlimited PV Amount Approval"; Boolean) { }
        field(39003904; "PV Amount Approval Limit"; Decimal) { }
        field(39003905; "Unlimited PettyAmount Approval"; Boolean) { }
        field(39003906; "Petty C Amount Approval Limit"; Decimal) { }
        field(39003907; "Unlimited Imprest Amt Approval"; Boolean) { }
        field(39003908; "Imprest Amount Approval Limit"; Decimal) { }
        field(39003909; "Unlimited Store RqAmt Approval"; Boolean) { }
        field(39003910; "Store Req. Amt Approval Limit"; Decimal) { }
        field(39003911; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(39003912; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'School Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(39003913; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
        field(39003914; "Unlimited ImprestSurr Amt Appr"; Boolean) { }
        field(39003915; "ImprestSurr Amt Approval Limit"; Decimal) { }
        field(39003916; "Unlimited Interbank Amt Appr"; Boolean) { }
        field(39003917; "Interbank Amt Approval Limit"; Decimal) { }
        field(39003918; "Staff Travel Account"; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(39003919; "Post JVs"; Boolean) { }
        field(39003920; "Post Batch Receipts"; Boolean) { }
        field(39003921; "Unlimited Receipt Amt Approval"; Boolean) { }
        field(39003922; "Receipt Amt Approval Limit"; Decimal) { }
        field(39003923; "Unlimited Claim Amt Approval"; Boolean) { }
        field(39003924; "Claim Amt Approval Limit"; Decimal) { }
        field(39003925; "Unlimited Advance Amt Approval"; Boolean) { }
        field(39003926; "Advance Amt Approval Limit"; Decimal) { }
        field(39003927; "Unlimited AdvSurr Amt Approval"; Boolean) { }
        field(39003928; "AdvSurr Amt Approval Limit"; Decimal) { }
        field(39003929; "Other Advance Staff Account"; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(39003930; "Unlimited Grant Amt Approval"; Boolean) { }
        field(39003931; "Grant Amt Approval Limit"; Decimal) { }
        field(39003932; "Unlimited GrantSurr Approval"; Boolean) { }
        field(39003933; "GrantSurr Amt Approval Limit"; Decimal) { }
        field(39003934; "User Signature"; Blob)
        {
            Caption = 'User Signature';
            SubType = Bitmap;
        }
        field(39003935; "Post Staff Grants"; Boolean) { }
        field(39004278; "ReValidate LPOs"; Boolean)
        {
            Description = 'Can ReOpen Expired LPOs';
        }
        field(39004279; "Procurement Officer"; Boolean) { }
        field(39004280; "Compliance/Grants"; Boolean) { }
        field(39004281; "Payroll Code"; Code[20])
        {
            TableRelation = "PR Employee Posting Groups";
        }
        field(39004282; test; Text[30]) { }
        field(39004283; "Archiving User"; Code[20])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(39004284; "Allow Transaction Reversal"; Boolean) { }
        field(39004285; "Reverse Hostel Allocations"; Boolean) { }
        field(39004286; "Perform Hostel Transfers"; Boolean) { }
        field(39004287; "Perform Hostel Switching"; Boolean) { }
        field(39004288; "Can Assign Lecturer Unit"; Boolean) { }
        field(39004289; "Can Allow Exam Attendance"; Boolean) { }
        field(39004290; "Can Edit Marks"; Boolean) { }
        field(70134290; "Medical Team"; Boolean) { }
        field(70134291; "Can Create Student"; Boolean) { }
        field(70134293; "Can Change Profile"; Boolean) { }


        field(39004291; "Can Exempt Units"; Boolean) { }
        field(39004292; "Allow Late Registration"; Boolean) { }
        field(51100; "QMS Auditor?"; Boolean) { }
        field(51101; "QMS PO?"; Boolean) { }
        field(51102; "QMS MR?"; Boolean) { }
        field(51103; "QMS VC?"; Boolean) { }
        field(51104; "QMS Admin?"; Boolean) { }
        field(51105; "Chief Internal Auditor?"; Boolean) { }
        field(51106; "Internal Auditor?"; Boolean) { }
        field(51107; "University VC?"; Boolean) { }
        field(39004305; Signature; Blob)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(39004306; "Cash Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."No." where("Bank Type" = const("Chq Collection"));
        }
        field(39004307; "Petty Cash Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."No." where("Bank Type" = const(Cash));
        }
        field(39004308; "Can Create Vendor"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(54308; "Can Create Bank"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(54318; "Can Create Item"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(54328; "Can Create G\L Account"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004309; "Can Edit Budget"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004310; "Multiple Banks"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004311; "Can Post Journal"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50343; "Can Create Asset"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50344; "Can Post Bank Recon."; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004312; "Selling Point"; Code[50])
        {
            DataClassification = ToBeClassified;
            //   TableRelation = "Catering Sale Points".Code;
        }
        field(39004313; "Can Create Customer"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134680; "Can Receipt Student"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70135680; "Can Reopen Order"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134681; "View Payroll"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134682; "Assign Role Center"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134683; "Allow Change Workflow"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134684; "Can Publish Tender"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134685; "IP Address"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(70134686; "Can Manage Workflow"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134687; "Can Clear Finance"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134688; "Can Clear Store"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134689; "Can Clear Footwear section"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134690; "Can Clear Leather section"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134691; "Can Clear Laboratory"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134692; "Can Clear Human Resource"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134693; "Can Clear Centre Administrator"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134694; "Is RFQ Administrator"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134695; "Legal"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134696; "Can Issue Asset"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134697; "Can Release Open PO"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50130; "Allow Open My Settings"; Boolean)
        {
            Caption = 'Allow Open My Settings';
            DataClassification = CustomerContent;
        }
        field(50131; "Allow Change Role"; Boolean)
        {
            Caption = 'Allow Change Role';
            DataClassification = CustomerContent;
        }
        field(50132; "Allow Change Company"; Boolean)
        {
            Caption = 'Allow Change Company';
            DataClassification = CustomerContent;
        }
        field(50133; "Allow Change Work Day"; Boolean)
        {
            Caption = 'Allow Change Work Day';
            DataClassification = CustomerContent;
        }
        field(50134;"Can Post Stock Adjustment";Boolean){}
    }

    //Unsupported feature: Property Deletion (ReplicateData).


    var
        Staff: Record "HR-Employee";
}

