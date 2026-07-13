page 50218 "Workplan Card"
{

    PageType = Card;
    UsageCategory = Documents;
    ApplicationArea = All;
    PromotedActionCategories = 'New,Process,Reports,Functions';
    SourceTable = "Workplan";
    SourceTableView = WHERE("Closed" = FILTER(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Workplan Card';

                field("Workplan Code."; Rec."Workplan Code.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Workplan Code. field.';
                }

                field("Workplan Description"; Rec."Workplan Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Workplan Description field.';
                }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }

                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }

                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }


                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocked field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Board Approved"; Rec."Board Approved")
                {
                    ApplicationArea = All;
                    editable = false;
                    ToolTip = 'Specifies the value of the Board Approved field.';
                }
                field("Financial Year"; Rec."Financial Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Financial Year field.';
                    trigger OnValidate()
                    var
                        ObjWpLines: Record "Workplan Activities";
                    begin
                        ObjWpLines.Reset();
                        ObjWpLines.SetRange("Procurement Workplan Code", Rec."Workplan Code.");
                        if ObjWpLines.Find('-') then begin
                            repeat
                                ObjWpLines."Financial Year" := Rec."Financial Year";
                                ObjWpLines.Modify();
                            until ObjWpLines.Next = 0;
                        end
                    end;
                }

            }

            part("Departmental WP Activities"; "Departmental WP Activities")
            {

                SubPageLink = "Procurement Workplan Code" = field("Workplan Code.");
                ApplicationArea = all;
            }

        }

    }
    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                Visible = true;

                action("&Import")
                {
                    Caption = '&Import';
                    Ellipsis = true;
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = xmlport "Import Workplan Activites";
                    ToolTip = 'Executes the &Import action.';
                }
                action("&Print")
                {
                    Caption = '&Export';
                    Ellipsis = true;
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = xmlport "Export Workplan Activites";
                    ToolTip = 'Executes the &Export action.';
                }
                group(RequestApproval)
                {
                    Caption = 'Request Approval';
                    action(BoardApprovalRequest)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Board A&pproval Request';
                        // Enabled = not OpenApprovalEntriesExist;
                        Image = SendApprovalRequest;
                        Promoted = true;
                        PromotedCategory = Category4;
                        ToolTip = 'Executes the Board A&pproval Request action.';
                        trigger OnAction()
                        var
                        //PurchaseQuoteLine: Record "Purchase Quote Line";
                        //QuotationRequestVendors: record "Quotation Request Vendors";
                        //PurchaseHeader: record "Purchase Header";
                        //PurchaseLines: Record "Purchase Line";
                        begin
                            IF CONFIRM('Board Approved?', FALSE) = FALSE THEN BEGIN EXIT END;

                            Rec."Board Approved" := true;
                        END;
                    }

                    action(SendApprovalRequest)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Send A&pproval Request';
                        // Enabled = not OpenApprovalEntriesExist;
                        Image = SendApprovalRequest;
                        Promoted = true;
                        PromotedCategory = Category4;
                        ToolTip = 'Executes the Send A&pproval Request action.';

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
                            VarVariant: Variant;

                        begin
                            VarVariant := Rec;
                            if ApprovalsMgmt.CheckApprovalsWorkflowEnabled(VarVariant) then
                                ApprovalsMgmt.OnSendDocForApproval(VarVariant);
                        end;
                    }
                    action(CancelApprovalRequest)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Cancel Approval Re&quest';
                        // Enabled = OpenApprovalEntriesExist;
                        Image = Cancel;
                        Promoted = true;
                        PromotedCategory = Category4;
                        ToolTip = 'Executes the Cancel Approval Re&quest action.';

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
                            VarVariant: Variant;

                        begin
                            VarVariant := Rec;

                            ApprovalsMgmt.OnCancelDocApprovalRequest(VarVariant);
                        end;
                    }
                }
                group(Navigate)
                {
                    Caption = 'Navigate';
                    action(Approvals)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Approvals';
                        Image = Approvals;
                        Promoted = true;
                        PromotedCategory = Category4;
                        ToolTip = 'Executes the Approvals action.';

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                        end;
                    }
                }
            }
        }
    }
}