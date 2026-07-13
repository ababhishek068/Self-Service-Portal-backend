Page 51150 "Contract Card"
{


    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Functions';
    SourceTable = Contract;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Contract Reference No"; Rec."Contract Reference No")
                {
                    ToolTip = 'Specifies the value of the Contract Reference No field.';
                }
                field("Contract Name";"Contract Name"){}
                field("Tender No";"Tender No"){}
                field("Tender name";"Tender name"){
                    Editable=false;
                }
                
                field("Contract Type"; Rec."Contract Type")
                {
                    ToolTip = 'Specifies the value of the Contract Type field.';
                }
                field("Contractor No."; Rec."Contractor No.")
                {
                    ToolTip = 'Specifies the value of the Contractor No. field.';
                }
                field("Contractor Name"; Rec."Contractor Name")
                {
                    ToolTip = 'Specifies the value of the Contractor Name field.';
                }
                field("Procurement Method"; Rec."Procurement Method")
                {
                    ToolTip = 'Specifies the value of the Procurement Method field.';
                }
                
                field("Effective Date"; Rec."Effective Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.';
                }
                field(Duration; Rec.Duration)
                {
                    ToolTip = 'Specifies the value of the Duration field.';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Expiry Date field.';
                }
                field("Contract Value"; Rec."Contract Value")
                {
                    ToolTip = 'Specifies the value of the Contract Value field.';
                }
                field("Milestone Amount"; Rec."Milestone Amount")
                {
                    ToolTip = 'Specifies the value of the Milestone Amount field.';
                }
                field("Milestone Balance"; Rec."Milestone Balance")
                {
                    ToolTip = 'Specifies the value of the Milestone Balance field.';
                }
                // field("Paid Milestone"; Rec."Paid Milestone")
                // {
                //     ToolTip = 'Specifies the value of the Paid Milestone field.';
                // }
                // field("Unpaid Milestone"; Rec."Unpaid Milestone")
                // {
                //     ToolTip = 'Specifies the value of the Unpaid Milestone field.';
                // }
                // field(Prepaid;Prepaid){}
                // field("Invoice Period";"Invoice Period"){}
                // field("Installment Amount";"Installment Amount"){}
                // field("Last payment Date";"Last payment Date"){}
                // field("Next Payment Period Start";"Next Payment Period Start"){}
                // field("Next Payment Period End";"Next Payment Period End"){}
                // field("Next Payment Date";"Next Payment Date"){}
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Subject Matter"; Rec."Subject Matter")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Subject Matter field.';
                }
                field(Recommendation; Rec.Recommendation)
                {
                    ToolTip = 'Specifies the value of the Recommendation field.';

                }
                field("Remarks Section"; Rec."Remarks Section")
                {
                    Caption = 'Remarks';
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Requested By"; Rec."Requested By")
                {
                    Caption = 'Prepared By';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Prepared By field.';
                }
                field(Active; Rec.Active)
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Active field.';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Has CIT"; Rec."Has CIT")
                {
                    Caption='TIC';
                    ToolTip = 'Specifies the value of the Has Tender Implementation Committee field.';

                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ToolTip = 'Specifies the value of the Termination Date field.';
                    // Editable = false;
                }
                field("Termination Remarks"; Rec."Termination Remarks")
                {
                    ToolTip = 'Specifies the value of the Termination Remarks field.';
                    // Editable = false;
                }
            }
            group(PB)
            {
                Caption='Perfomance Bond Information';
                field("Perfomance Bond";"Perfomance Bond"){}
                field("Perfomance Bond Amount";"Perfomance Bond Amount"){}
                field("Perfomance Bond Ref No";"Perfomance Bond Ref No"){}
                field("PB Bank Name";"PB Bank Name"){}
                field("PB Issue Date";"PB Issue Date"){}
                field("Perfomance Bond Start Date";"Perfomance Bond Start Date"){}
                field("PB Period";"PB Period"){}
                field("Perfomance Bond End Date";"Perfomance Bond End Date"){
                    caption= 'Perfomance Bond Expiry Date';
                    Editable=false;
                }
                field("PB Confirmed?";"PB Confirmed?"){}
                field("PB Confirmation Ref";"PB Confirmation Ref"){}
                field("PB Confirmation Date";"PB Confirmation Date"){}
                field("PB Notification of Expiry done?";"PB Notification of Expiry done?"){}
                field("PB Date Notified";"PB Date Notified"){}
                field("PB Notification Ref";"PB Notification Ref"){}
                field("PB Extended?";"PB Extended?"){}
                field("PB Extension Start date";"PB Extension Start date"){}
                field("PB Extension End date";"PB Extension End date"){}
            }
            group(PG)
            {
                Caption='Advance Payment Guarantee Information';
                 field("Payment Guarantee?";"Payment Guarantee?"){}
                field("Payment Guarantee Amount";"Payment Guarantee Amount"){}
                field("Percentage Guarantee";rec."% of Contract Value"){}
                field("Payment Voucher No";"Payment Voucher No"){}
                field("PG Bank Name";"PG Bank Name"){}
                field("PG Issue Date";"PG Issue Date"){}
                field("PG  Start Date";"PG  Start Date"){}
                field("PG Period";"PG Period"){}
                field("PG End Date";"PG End Date"){
                    Editable=false;
                    Caption='Payment Gurantee Expiry Date';
                }
                field("PG Confirmed?";"PG Confirmed?"){}
                field("PG Confirmation Ref";"PG Confirmation Ref"){}
                field("PG Confirmation Date";"PG Confirmation Date"){}
                field("PG Notification of Expiry done?";"PG Notification of Expiry done?"){}
                field("PG Date Notified";"PG Date Notified"){}
                field("PG Notification Ref";"PG Notification Ref"){}
                field("PG Extended?";"PG Extended?"){}
                field("PG Extension Start date";"PG Extension Start date"){}
                field("PG Extension End date";"PG Extension End date"){}
                
            }
            part(addd; "Contract Addendum List")
            {
                SubPageLink = "Contract Reference No" = field("Contract No.");
            }
        }
        area(FactBoxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(70134881),
                              "No." = FIELD("Contract Reference No");
            }
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
        area(navigation)
        {
            group("&Functions")
            {
                Caption = 'Functions';
                Image = FileContract;
                action("Send A&pproval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Send A&pproval Request action.';

                    trigger OnAction()
                    begin
                        IF NOT Rec.HASLINKS THEN
                            ERROR('Please attach documents on the links page');

                        VarVariant := Rec;
                        IF ApprovalsMgmt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                            ApprovalsMgmt.OnSendDocForApproval(VarVariant);
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
                    var
                        ApprovalsMgmt1: Codeunit "Approvals Mgmt.";
                    begin

                        ApprovalsMgmt1.OpenApprovalEntriesPage(Rec.RECORDID)
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';

                    trigger OnAction()
                    begin

                        VarVariant := Rec;
                        ApprovalsMgmt.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }
                action("Contract Milestones")
                {
                    Image = LineReserve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Contract Milestones action.';
                    RunObject = Page "Contract Milestones";
                    RunPageLink = "Contract No" = FIELD("Contract Reference No");
                    trigger OnAction()
                    var
                        MileStones: Record "Contract Milestones";
                        Committee: Record "Tender Committee";
                    begin
                        if Rec."Has CIT" = true then begin
                            Committee.Reset();
                            Committee.SetRange("Tendor No", Rec."Contract Reference No");
                            Committee.SetRange("Committee Type", Committee."Committee Type"::"Contract Implementation Team");
                            if not Committee.Find('-') then Error('Please setup the Implementation Committee');
                            MileStones.Reset();
                            MileStones.SetFilter("Contract No", Rec."Contract Reference No");
                            if MileStones.Find('-') then
                                Page.Run(Page::"Contract Milestones", MileStones);
                        end;
                        MileStones.Reset();
                        MileStones.SetFilter("Contract No", Rec."Contract Reference No");
                        if MileStones.Find('-') then
                            Page.Run(Page::"Contract Milestones", MileStones);
                    end;

                }
                action(Attachments)
                {
                    Image = Attachments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Document Attachment Details";
                    RunPageLink = "No." = field("Contract Reference No");
                    ToolTip = 'Executes the Attachments action.';
                    trigger OnAction()
                    begin
                    end;
                }
                action("Activate Contract")
                {
                    Image = ActivateDiscounts;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Activate Contract action.';

                    trigger OnAction()
                    begin

                        if Confirm('Are you sure you want activate this contract?', false) then begin
                            if not Rec.HasLinks then Error('Please attach the contract document.');
                            Rec.TestField("Contract No.");
                            Rec.TestField("Expiry Date");
                            Rec.TestField("Contract Value");
                            Rec.TestField("Effective Date");
                            Rec.Status := Rec.Status::Approved;
                            Rec.Active := true;
                        end else
                            Error('Process Aborted');
                    end;

                }
                action("Print Contract Certificate ")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Print Contract Certificate  action.';

                    trigger OnAction()
                    begin
                        Contract.RESET();
                        Contract.SETRANGE("Contract Reference No", Rec."Contract Reference No");
                        IF Contract.FINDFIRST THEN BEGIN
                            REPORT.RUN(70135232, TRUE, TRUE, Contract);
                        END;
                    end;
                }

                action("Contract Extensions")
                {
                    Image = Timesheet;
                    Caption='Contract Amendment/Extension';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Contract Renewals";
                    RunPageLink = "Contract Reference No" = FIELD("Contract Reference No"),
                                  "Contract Type" = FIELD("Contract Type"),
                                  "Contractor No." = field("Contractor No.");
                    ToolTip = 'Executes the Contract Extensions action.';
                }
                action(Committee)
                {
                    Image = Users;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Caption = 'Contract Implementation Committee';
                    RunObject = page "Tender Committee";
                    RunPageLink = "Tendor No" = field("Contract Reference No"), "Committee Type" = filter('Contract Implementation Team');
                    ToolTip = 'Executes the Contract Implementation Committee action.';
                }

                action("Renew Contract")
                {
                    ToolTip = 'Executes the Renew Contract action.';
                }
                action("Terminate Contract")
                {
                    ToolTip = 'Executes the Terminate Contract action.';

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you wish to terminate this contract?', FALSE) = TRUE THEN BEGIN
                            Rec.TESTFIELD("Termination Date");
                            Rec.Status := Rec.Status::Terminated;
                            Rec.MODIFY;
                        END;

                        MESSAGE('Process complete');
                    end;
                }
                action("Mark asn Board Approved")
                {
                    ToolTip = 'Executes the Mark asn Board Approved action.';

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you wish to mark this contract as board approved?', FALSE) = TRUE THEN BEGIN
                            Rec."Board Approved" := TRUE;
                            Rec.MODIFY;
                        END;

                        MESSAGE('Process complete');
                    end;
                }

            }
        }
    }

    trigger OnInit()
    begin
        IF Rec.Status <> Rec.Status::Open THEN
            CurrPage.EDITABLE(FALSE);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Requested By" := USERID;
    end;

    trigger OnOpenPage()
    begin


        IF Rec.Status <> Rec.Status::Open THEN
            CurrPage.EDITABLE(FALSE);
    end;

    var
        VarVariant: Variant;
        ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
        Contract: Record Contract;
}

