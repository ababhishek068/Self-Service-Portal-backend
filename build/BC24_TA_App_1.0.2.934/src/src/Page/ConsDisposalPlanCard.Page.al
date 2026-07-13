page 50255 "Cons. Disposal Plan Card"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Functions,Consolidate';
    SourceTable = "Cons.Disposal Plan";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("General Details")
            {
                Caption = 'General Details';
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Disposal Period"; Rec."Disposal Period")
                {
                    ToolTip = 'Specifies the value of the Disposal Period field.';

                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Approved By Board"; Rec."Approved By Board")
                {
                    ToolTip = 'Specifies the value of the Approved By Board field.';
                }
                field("Approved By Committee"; Rec."Approved By Committee")
                {
                    ToolTip = 'Specifies the value of the Approved By Committee field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Function Name"; Rec."Function Name")
                {
                    ToolTip = 'Specifies the value of the Function Name field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    ToolTip = 'Specifies the value of the Budget Center Name field.';
                }
            }
            part("Consolidated Disposal"; "Consolidated Disposal")
            {
                SubPageLink = "Disposal  No" = FIELD("Document No.");
            }
        }
        area(factboxes)
        {
            systempart(Outlook; Outlook) { }
            part(MyPart; "Acc. Sched. KPI Web Srv. Lines")
            {
                ApplicationArea = All;
                SubPageView = SORTING("Acc. Schedule Name");
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
        area(processing)
        {
            group(Dispose)
            {
                action("Dispose Asset")
                {
                    Caption = 'Dispose Asset';
                    Image = Excise;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Dispose Asset action.';
                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::Approved);
                        SalesHeader.Reset();
                        SalesHeader.Init();
                        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                        SalesHeader.Validate("Document Type");
                        SalesHeader.Validate("No.");
                        SalesHeader."Posting Description" := Rec.Description;
                        SalesHeader."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                        SalesHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                        SalesHeader.Insert(true);
                        Page.Run(43, SalesHeader);
                        CurrPage.Close();
                    end;
                }
                action("BoardApproved")
                {
                    Caption = 'Mark as Board Approved';
                    Image = Approvals;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Mark as Board Approved action.';

                    trigger OnAction();
                    begin
                        if Confirm('You are about to Mark the disposal plan for ' + Rec."Disposal Period" + ' Disposal Period as Board Approved. Do you want to proceed?') = true then begin
                            ConsDisLines.Reset();
                            ConsDisLines.SetRange("Disposal Period", Rec."Disposal Period");
                            if ConsDisLines.Find('-') then begin
                                repeat
                                    ConsDisLines."Board Approved" := true;
                                    ConsDisLines.Modify();
                                until ConsDisLines.Next = 0;
                                CurrPage.Update();
                                Message('Success');
                            end;
                        end else
                            error('Process Aborted');
                    end;
                }
            }
            group(Consolidation)
            {
                action("Consolidate Disposal Plan")
                {
                    Caption = 'Consolidate Disposal Plan';
                    Image = PhysicalInventory;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Consolidate Disposal Plan action.';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Disposal Period");


                        IF CONFIRM('Do you wish to consolidate disposal plan?', FALSE) = FALSE THEN ERROR('Process aborted');

                        DisposalPlanHeader.RESET;
                        DisposalPlanHeader.SETRANGE("Disposal Period", Rec."Disposal Period");
                        DisposalPlanHeader.SETRANGE(Status, DisposalPlanHeader.Status::Approved);
                        DisposalPlanHeader.SETRANGE(Disposed, FALSE);
                        DisposalPlanHeader.FINDSET();
                        BEGIN
                            REPEAT
                                DisposalPlanLines.RESET;
                                DisposalPlanLines.SETRANGE("Disposal  No", DisposalPlanHeader."Disposal No.");
                                IF DisposalPlanLines.FINDSET(FALSE, FALSE) THEN BEGIN
                                    REPEAT
                                        ConsDisposalLines."Disposal  No" := Rec."Document No.";
                                        ConsDisposalLines."Line No." := fn_lastLine;
                                        ConsDisposalLines."No." := DisposalPlanLines."No.";
                                        ConsDisposalLines.Type := DisposalPlanLines.Type;
                                        ConsDisposalLines.Description := DisposalPlanLines.Description;
                                        ConsDisposalLines."Description 2" := DisposalPlanLines."Description 2";
                                        ConsDisposalLines."Quantity Issued" := DisposalPlanLines."Quantity Issued";
                                        ConsDisposalLines."Quantity Requested" := DisposalPlanLines."Quantity Requested";
                                        ConsDisposalLines."Quantity To Issue" := DisposalPlanLines."Quantity To Issue";
                                        ConsDisposalLines."Qty in store" := DisposalPlanLines."Qty in store";
                                        ConsDisposalLines."Request Status" := DisposalPlanLines."Request Status";
                                        ConsDisposalLines."Action Type" := DisposalPlanLines."Action Type";
                                        ConsDisposalLines."Actual Quantity" := DisposalPlanLines."Actual Quantity";
                                        ConsDisposalLines.Committed := DisposalPlanLines.Committed;
                                        ConsDisposalLines."Unit of Measure" := DisposalPlanLines."Unit of Measure";
                                        ConsDisposalLines."Unit Cost" := DisposalPlanLines."Unit Cost";
                                        ConsDisposalLines."Current Actuals Amount" := DisposalPlanLines."Current Actuals Amount";
                                        ConsDisposalLines."Current Month Budget" := DisposalPlanLines."Current Month Budget";
                                        ConsDisposalLines."Line Amount" := DisposalPlanLines."Line Amount";
                                        ConsDisposalLines."Shortcut Dimension 1 Code" := DisposalPlanLines."Shortcut Dimension 1 Code";
                                        ConsDisposalLines."Shortcut Dimension 2 Code" := DisposalPlanLines."Shortcut Dimension 2 Code";
                                        ConsDisposalLines."Shortcut Dimension 3 Code" := DisposalPlanLines."Shortcut Dimension 3 Code";
                                        ConsDisposalLines."Shortcut Dimension 4 Code" := DisposalPlanLines."Shortcut Dimension 4 Code";
                                        ConsDisposalLines."Issuing Store" := DisposalPlanLines."Issuing Store";
                                        ConsDisposalLines."Issue Quantity" := DisposalPlanLines."Issue Quantity";
                                        ConsDisposalLines."Requested by" := DisposalPlanLines."Requested by";
                                        ConsDisposalLines."Planned Quantity" := DisposalPlanLines."Planned Quantity";
                                        ConsDisposalLines."Actual Quantity" := DisposalPlanLines."Actual Quantity";
                                        ConsDisposalLines."Reserved Price" := DisposalPlanLines."Reserved Price";
                                        ConsDisposalLines."Price Disposed" := DisposalPlanLines."Price Disposed";
                                        ConsDisposalLines."Justification For Disposal" := DisposalPlanLines."Justification For Disposal";
                                        ConsDisposalLines."Total Price" := DisposalPlanLines."Total Price";
                                        ConsDisposalLines."Total Budget" := DisposalPlanLines."Total Budget";
                                        ConsDisposalLines."Item Life Span" := DisposalPlanLines."Item Life Span";
                                        ConsDisposalLines."Fixed Location" := DisposalPlanLines."Fixed Location";
                                        ConsDisposalLines."Tag No." := DisposalPlanLines."Tag No.";
                                        ConsDisposalLines."Disposal Method" := DisposalPlanLines."Disposal Method";
                                        ConsDisposalLines."Disposal Period" := Rec."Disposal Period";
                                        ConsDisposalLines.Disposed := DisposalPlanLines.Disposed;

                                        ConsDisposalLines.INSERT;

                                    UNTIL DisposalPlanLines.NEXT() = 0;
                                    MESSAGE('Process complete');
                                END;
                                DisposalPlanHeader.Consolidated := TRUE;
                                DisposalPlanHeader.MODIFY;
                            UNTIL DisposalPlanHeader.NEXT() = 0;
                        END;
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Send A&pproval Request action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Pending);

                        VarVariant := Rec;
                        IF ApprovalsMgmt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                            ApprovalsMgmt.OnSendDocForApproval(VarVariant);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::"Pending Approval");
                        VarVariant := Rec;
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

                    trigger OnAction()
                    begin
                        //ApprovalsMgmt.OpenApprovalEntriesPage(RECORDID)
                    end;
                }
                action(PrintPreview)
                {
                    Caption = 'PrintPreview';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    ToolTip = 'Executes the PrintPreview action.';

                    trigger OnAction()
                    begin
                        Rec.RESET;
                        Rec.SETFILTER("Document No.", Rec."Document No.");
                        //REPORT.RUN(REPORT::"Cons. Finance Workplan", TRUE, FALSE, Rec);
                        Rec.RESET;
                    end;
                }
            }
        }
    }

    var
        ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
        VarVariant: Variant;
        DisposalPlanHeader: Record "Disposal Plan Header";
        DisposalPlanLines: Record "Disposal Plan Lines";
        ConsDisposalLines: Record "Cons. Disposal Plan Lines";
        SalesHeader: Record "Sales Header";
        ConsDisLines: Record "Cons. Disposal Plan Lines";

    local procedure fn_lastLine(): Integer
    var
        ConsDisPLan_2: Record "Cons. Disposal Plan Lines";
    begin
        ConsDisPLan_2.RESET;
        IF ConsDisPLan_2.FINDLAST THEN BEGIN
            EXIT(ConsDisPLan_2."Line No." + 1);
        END ELSE BEGIN
            EXIT(1);
        END;
    end;
}

