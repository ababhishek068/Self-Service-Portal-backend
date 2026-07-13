page 50343 "Vendor User Buffer Card"
{
    SourceTable = "Vendor User Buffer";
    Caption = 'Pre-qualified Suppliers';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(UserID; Rec.UserID)
                {
                    ToolTip = 'Specifies the value of the UserID field.';
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field.';
                }
                field(Ownership; Rec.Ownership)
                {
                    ToolTip = 'Specifies the value of the Ownership field.';
                }
                field("Company Registration No"; Rec."Company Registration No")
                {
                    ToolTip = 'Specifies the value of the Company Registration No field.';
                }
                field("Vendor No"; Rec."Vendor No")
                {
                    ToolTip = 'Specifies the value of the Vendor No field.';
                }
            }
            group("Contact Information")
            {
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field("Telephone No"; Rec."Telephone No")
                {
                    ToolTip = 'Specifies the value of the Telephone No field.';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Kra Pin"; Rec."Kra Pin")
                {
                    ToolTip = 'Specifies the value of the Kra Pin field.';
                }
                field(Language; Rec.Language)
                {
                    ToolTip = 'Specifies the value of the Language field.';
                }
                field(Country; Rec.Country)
                {
                    ToolTip = 'Specifies the value of the Country field.';
                }
                field(Password; Rec.Password)
                {
                    HideValue = true;
                    ToolTip = 'Specifies the value of the Password field.';
                }
                field("Street Address/Building No"; Rec."Street Address/Building No")
                {
                    ToolTip = 'Specifies the value of the Street Address/Building No field.';
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.';
                }
                field("Postal Code"; Rec."Postal Code")
                {
                    ToolTip = 'Specifies the value of the Postal Code field.';
                }
                field("Mobile Phone"; Rec."Mobile Phone")
                {
                    ToolTip = 'Specifies the value of the Mobile Phone field.';
                }
                field("Vendor Category"; Rec."Vendor Category")
                {
                    ToolTip = 'Specifies the value of the Vendor Category field.';

                }
                field("Rejection Comments"; Rec."Rejection Comments")
                {
                    ToolTip = 'Specifies the value of the Rejection Comments field.';
                }

            }
            group(Pictures)
            {
                field(Logo; Rec.Logo)
                {
                    ToolTip = 'Specifies the value of the Logo field.';
                }
                field("KRA Pin Attached"; Rec."KRA Pin Attached")
                {
                    ToolTip = 'Specifies the value of the KRA Pin Attached field.';
                }
                field("TCC Attached"; Rec."TCC Attached")
                {
                    ToolTip = 'Specifies the value of the TCC Attached field.';
                }
                field("Certificate of Incorporation"; Rec."Certificate of Incorporation")
                {
                    ToolTip = 'Specifies the value of the Certificate of Incorporation field.';
                }
                field("CR12 Attached"; Rec."CR12 Attached")
                {
                    ToolTip = 'Specifies the value of the CR12 Attached field.';
                }
                field("Agpo Attached"; Rec."Agpo Attached")
                {
                    ToolTip = 'Specifies the value of the Agpo Attached field.';
                }
                field("Business Permit Attached"; Rec."Business Permit Attached")
                {
                    ToolTip = 'Specifies the value of the Business Permit Attached field.';
                }
                field("Direcort ID Attached"; Rec."Direcort ID Attached")
                {
                    ToolTip = 'Specifies the value of the Direcort ID Attached field.';
                }
            }
        }
        area(FactBoxes)
        {
            part(Attachment; "Document Attachments")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field(UserID);
            }

            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Attachments)
            {
                ApplicationArea = all;
                Image = Attachments;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = page "Document Attachments";
                RunPageLink = "No." = field(UserID);
                ToolTip = 'Executes the Attachments action.';
            }

            action("Send Approval Request")
            {
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Send Approval Request action.';

                trigger OnAction()
                var
                    SuppCu: Codeunit "Suppliers Portal";
                begin
                    SuppCu.SubmitRegistration(Rec."Company Registration No", Rec.UserID);
                end;
            }
            action("Cancel Approval Request")
            {
                Caption = 'Cancel Approval Request';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Cancel Approval Request action.';

                trigger OnAction()
                var
                    CustomApprovals: Codeunit "Custom Approvals Codeunit";
                    VarVariant: Variant;
                begin
                    VarVariant := Rec;
                    IF CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                end;
            }
            action("Approval Entries")
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "Approvals Mgmt.";
                    VarVariant: Variant;
                begin
                    VarVariant := Rec;
                    ApprovalMgt.OpenApprovalEntriesPage(VarVariant);
                end;
            }
        }
    }
}

