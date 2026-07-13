
page 51476 "Individualized Budget Card"
{
    ApplicationArea = All;
    Caption = 'Individualized Budget Card';
    PageType = Card;
    SourceTable = "Individualized Budgets";
    CardPageId="Individualized Budget";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Budget No"; Rec."Budget No")
                {
                    ToolTip = 'Specifies the value of the Budget Number field.', Comment = '%';
                }
                field("Financial Year"; Rec."Financial Year")
                {
                    ToolTip = 'Specifies the value of the Financial Year field.', Comment = '%';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.', Comment = '%';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.', Comment = '%';
                }
                field("GL account"; Rec."GL account")
                {
                    ToolTip = 'Specifies the value of the GL account field.', Comment = '%';
                }
                field("GL Name"; Rec."GL Name")
                {
                    ToolTip = 'Specifies the value of the GL Name field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Craeted field.', Comment = '%';
                }
                field("Total  Amount"; Rec."Total  Amount")
                {
                    ToolTip = 'Specifies the value of the Total  Amount field.', Comment = '%';
                }
                field("Total Expenditure"; Rec."Total Expenditure")
                {
                    ToolTip = 'Specifies the value of the Total Expenditure field.', Comment = '%';
                }
                field("Total Committments"; Rec."Total Committments")
                {
                    ToolTip = 'Specifies the value of the Total Committments field.', Comment = '%';
                }
                field(Balance; Rec.Balance)
                {
                    ToolTip = 'Specifies the value of the Balance field.', Comment = '%';
                }
            }
            part(BudgetLines; IndividualizedBudgetLine)
             //part(BudgetLines; "Purchase Requisition Subform")
            {
                Editable = true;
                SubPageLink = "Budget No" = field("Budget No"),"Gl Account"=field("Budget No"),"Department Code"=field("Department Code");
            }
            systempart(Control1900383207; Links)
            {
                Visible = true;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }

        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(38),
                              "No."= FIELD("Budget No");
            }

        }
        
        }

        actions
        {
            area(Navigation)
            {
                group("Approval Request")
            {
                Caption = 'Approval Request';
                action(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send Approval Request action.';

                    trigger OnAction();
                    var
                        VarVariant: Variant;
                    begin
                        // Rec.TestField(Status, Rec.Status::Open);
                        // Rec.testfield("Days Applied");
                        // Rec.TestField("Reason for leave");

                        // if Rec."Days Applied" > Rec."Earned Leave Days" then
                        //     Error('Days applied cannot exceed earned leave days');

                        // VarVariant := Rec;
                        // IF ApprovalsMgmt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                        //     ApprovalsMgmt.RunWorkflowOnSendApprovalRequest(VarVariant);
                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Approval Request action.';

                    trigger OnAction();
                    var
                        VarVariant: Variant;
                        ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
                    begin

                        VarVariant := Rec; //Added
                        ApprovalsMgmt.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }

                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RECORDID)
                    end;
                }
                


            }
                action("Print Preview")
            {
                ApplicationArea = Basic;
                Caption = 'Print Preview';
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Print Preview action.';
                trigger OnAction()
                var
                    Budget: record "Budget line";
                    repVend: Report "Individualized Budget";
                    //Individualized budget report
                begin
                    Budget.SetRecFilter;
                    Budget.SetFilter(Budget."GL account", Rec."GL account");
                    Budget.SetFilter("Budget No", Rec."Budget No");
                    Budget.SetFilter("Department Code",Rec."Department Code");
                    repVend.SetTableView(Budget);
                    repVend.Run;

                    /* QuotationRequestVendors.reset;
                    QuotationRequestVendors.setrange(QuotationRequestVendors."Requisition Document No.", "No.");
                    if QuotationRequestVendors.find('-') then begin
                        repeat
                            PurchaseQuoteHeader.reset;
                            PurchaseQuoteHeader.SETFILTER("No.", "No.");
                            PurchaseQuoteHeader.setfilter("Vendor No. Filter", QuotationRequestVendors."Vendor No.");
                            if PurchaseQuoteHeader.find('-') then
                                REPORT.RUN(REPORT::"Request Quotation Analysis", true, true, PurchaseQuoteHeader);
                        until QuotationRequestVendors.Next = 0;
                    end; */

                end;
            }
            }
        }
    }

