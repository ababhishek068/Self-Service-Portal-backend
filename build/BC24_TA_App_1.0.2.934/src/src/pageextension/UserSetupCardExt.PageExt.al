pageextension 50028 "User Setup Card Ext" extends "User Setup"
{
    layout
    {
        addafter("Time Sheet Admin.")
        {
            Field("View Payroll";Rec."View Payroll"){ApplicationArea = basic;}
            Field("Other Advance Staff Account"; Rec."Other Advance Staff Account")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Other Advance Staff Account field.';
            }
            Field("Imprest Account"; Rec."Imprest Account")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Imprest Account field.';
            }
            Field("Employee No."; Rec."Employee No.")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Employee No. field.';
            }
            field("Approval Title"; Rec."Approval Title")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Approval Title field.';
            }
            Field("PV Amount Approval Limit"; Rec."PV Amount Approval Limit")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the PV Amount Approval Limit field.';
            }
            Field("Unlimited PettyAmount Approval"; Rec."Unlimited PettyAmount Approval")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Unlimited PettyAmount Approval field.';
            }

            Field("Unlimited Imprest Amt Approval"; Rec."Unlimited Imprest Amt Approval")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Unlimited Imprest Amt Approval field.';
            }
            Field("Store Req. Amt Approval Limit"; Rec."Store Req. Amt Approval Limit")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Store Req. Amt Approval Limit field.';
            }
            Field("ImprestSurr Amt Approval Limit"; Rec."ImprestSurr Amt Approval Limit")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the ImprestSurr Amt Approval Limit field.';
            }
            Field("Unlimited Interbank Amt Appr"; Rec."Unlimited Interbank Amt Appr")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Unlimited Interbank Amt Appr field.';
            }
            Field("Can Create G\L Account"; Rec."Can Create G\L Account")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Can Create G\L Account field.';
            }
            Field("Can Create Customer"; Rec."Can Create Customer")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Can Create Customer field.';
            }
            Field("Can Create Vendor"; Rec."Can Create Vendor")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Can Create Vendor field.';
            }
            Field("Can Create Asset"; Rec."Can Create Asset")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Can Create Asset field.';
            }
            Field("Can Create Bank"; Rec."Can Create Bank")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Can Create Bank field.';
            }
            Field("Can Create Item"; Rec."Can Create Item")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Can Create Item field.';
            }
            Field("Can Post Bank Recon."; Rec."Can Post Bank Recon.")
            {
                Caption = 'Can Post Bank Reconcilliation';
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Can Post Bank Reconcilliation field.';
            }
            Field("Assign Role Center"; Rec."Assign Role Center")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Assign Role Center field.';
            }
            Field("Post JVs"; Rec."Post JVs")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Post JVs field.';
            }
            Field("Post Bank Rec"; Rec."Post Bank Rec")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Post Bank Rec field.';
            }

            Field("Unlimited Claim Amt Approval"; Rec."Unlimited Claim Amt Approval")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Unlimited Claim Amt Approval field.';
            }
            Field("Unlimited Receipt Amt Approval"; Rec."Unlimited Receipt Amt Approval")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Unlimited Receipt Amt Approval field.';
            }
            Field("Unlimited Advance Amt Approval"; Rec."Unlimited Advance Amt Approval")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Unlimited Advance Amt Approval field.';
            }
            Field("Unlimited AdvSurr Amt Approval"; Rec."Unlimited AdvSurr Amt Approval")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Unlimited AdvSurr Amt Approval field.';
            }
            Field("Allow Change Workflow"; Rec."Allow Change Workflow")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Allow Change Workflow field.';
            }
            Field("Medical Team"; Rec."Medical Team")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Medical Team field.';
            }
            field("Can Publish Tender"; Rec."Can Publish Tender")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Can Publish Tender field.';
            }
            field("Chief Internal Auditor?"; Rec."Chief Internal Auditor?")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Chief Internal Auditor? field.';
            }
            field("Internal Auditor?"; Rec."Internal Auditor?")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Internal Auditor? field.';
            }
            field("Can Change Profile"; Rec."Can Change Profile")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Can Change Profile field.';
            }
            field("Can Manage Workflow"; Rec."Can Manage Workflow")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Can Manage Workflow field.';
            }
            field("Is RFQ Administrator"; Rec."Is RFQ Administrator")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Is RFQ Administrator field.';
            }
            field(Legal; Rec.Legal)
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Legal field.';
            }
            field("Can Release Open PO"; Rec."Can Release Open PO")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Can Release Open PO field.';
            }
        }
    }
    actions
    {
        addlast(Navigation)
        {
            action(Card)
            {
                Caption = 'User Card';
                Image = User;
                ApplicationArea = basic;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "User Setup Card";
                RunPageLink = "User ID" = field("User ID");
                ToolTip = 'Executes the User Card action.';

            }
        }
    }
}