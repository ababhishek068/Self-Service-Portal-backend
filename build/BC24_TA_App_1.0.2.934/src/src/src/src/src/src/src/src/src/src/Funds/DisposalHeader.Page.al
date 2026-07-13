Page 51045 "Disposal Header"
{
    SourceTable = "Disposal Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(No; Rec."No.")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the No. field.';
            }
            field(DisposalPeriod; Rec."Disposal Period")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Disposal Period field.';
            }
            field(Desciption; Rec.Desciption)
            {
                ApplicationArea = Basic;
                Caption = 'Justification';
                ToolTip = 'Specifies the value of the Justification field.';
            }
            field(Date; Rec.Date)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Date field.';
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Status field.';
            }
            field(Department; Rec."Shortcut dimension 1 code")
            {
                ApplicationArea = Basic;
                Caption = 'Directorate';
                ToolTip = 'Specifies the value of the Directorate field.';
            }
            field(Region; Rec."Shortcut dimension 2 code")
            {
                ApplicationArea = Basic;
                Caption = 'Department';
                ToolTip = 'Specifies the value of the Department field.';
            }
            field(ResponsibilityCenter; Rec."Responsibility Center")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Responsibility Center field.';
            }
            field(DisposalPlanNo; Rec."Disposal Plan No.")
            {
                ApplicationArea = Basic;
                Visible = false;
                ToolTip = 'Specifies the value of the Disposal Plan No. field.';
            }
            field(Disposed; Rec.Disposed)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Disposed field.';
            }
            part(Control15; "Disposal Plan Lines")
            {
                SubPageLink = "No." = field("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send For Approval")
            {
                ApplicationArea = Basic;
                Caption = 'Send For Approval';
                Image = Aging;
                Promoted = true;
                ToolTip = 'Executes the Send For Approval action.';

                trigger OnAction()
                Var
                    Varr: Variant;
                begin
                    varr := rec;
                    if ApprovalsMgmt.CheckApprovalsWorkflowEnabled(Varr) then
                        ApprovalsMgmt.OnSendDocForApproval(varr);
                end;
            }
            action("Cancel Approval")
            {
                ApplicationArea = Basic;
                Caption = 'Cancel Approval';
                Image = Approve;
                Promoted = true;
                ToolTip = 'Executes the Cancel Approval action.';

                trigger OnAction()
                Var
                    Varr: Variant;
                begin
                    //ApprovalMgt.CancelDisposalAppRequest(Rec,TRUE,TRUE);
                    ApprovalsMgmt.OnCancelDocApprovalRequest(varr);
                end;
            }
            action("Accept Disposal")
            {
                ApplicationArea = Basic;
                Image = Approve;
                Promoted = true;
                ToolTip = 'Executes the Accept Disposal action.';

                trigger OnAction()
                var
                    Lines: Record "Disposal Line";
                begin

                    Rec.TestField(Status, Rec.Status::Approved);
                    //IF DisposalLine.Confirmed <> TRUE THEN ERROR('Please Enter Disposed To');
                    //DisposalLine.TESTFIELD(DisposalLine."Disposed To");
                    //DisposalLine.TESTFIELD(DisposalLine."Confirmed By");

                    //IF CONFIRM('Are you sure you want to Dispose this item?')  THEN BEGIN
                    Rec."Disposal Status" := Rec."disposal status"::"Tender Committee";
                    //IF  DisposalLine."Disposal Methods"<>'OT' THEN
                    //ERROR('You need to send it to Tender Committee');
                    //IF "Disposal Status":="Disposal Status":: "TENDER COMMITTEE" THEN
                    Rec.Disposed := true;
                    /*MESSAGE('Disposal Number %1 has been Implemented',"No.");
                  END;


                 CLEAR(OTExists);
                 TESTFIELD(Status,Status::Approved);
                 //IF CONFIRM('Are you sure you want to Dispose this item?')  THEN BEGIN
                  "Disposal Status":="Disposal Status"::"Tender Committee";
                 CLEAR(OTExists);
                 DisposalLine.RESET;
                 DisposalLine.SETRANGE(DisposalLine."Disposal No","Disposal Plan No.");
                 IF DisposalLine.FIND('-') THEN  BEGIN
                 REPEAT

                 IF  DisposalLine."Disposal Methods"='OT' THEN
                  DisposalLine.Disposed:=TRUE;
                 IF Lines.FIND('-') THEN
                  BEGIN
                    REPEAT
                   Lines.Disposed:=TRUE;
                   UNTIL Lines.NEXT=0;
                   MODIFY;
                   END;


                 OTExists:=TRUE;

                 UNTIL DisposalLine.NEXT=0;
                 END;
                  IF OTExists THEN

                 //IF  DisposalLine."Disposal Methods"<>'OT' THEN
                 //ERROR('You need to send it to Tender Committee');
                  DisposalLine.Disposed:=TRUE;
                  Disposed:=TRUE;
                   MODIFY;
                    //MESSAGE('Disposal Number %1 has been Implemented',"No.");
                   //END;

                 // dispose lines // */


                    Clear(OTExists);
                    DisposalLine.Reset;
                    DisposalLine.SetRange(DisposalLine."No.", Rec."No.");
                    if DisposalLine.Find('-') then begin
                        DisposalLine.TestField(DisposalLine."Disposed To");
                        DisposalLine.TestField(DisposalLine."Confirmed By");

                        repeat

                            if DisposalLine."Disposal Methods" = 'OT' then
                                DisposalLine.TestField(DisposalLine."Total Price");

                            OTExists := true;

                        until DisposalLine.Next = 0;
                    end;
                    if OTExists then
                        Rec."Disposal Status" := Rec."disposal status"::Disposed
                    else
                        Rec."Disposal Status" := Rec."disposal status"::"Disposal implementation";
                    Rec.Modify;

                    //MESSAGE('Disposal Number %1 has been Send To Tender Committee"',"No.");



                    if Confirm('Do you want to Dispose Lines?', true) = false then exit;
                    Rec.Reset;
                    Rec.SetRange("No.", Lines."Disposal Plan No.");
                    if Lines.Find('-') then
                        Lines.Disposed := true;
                    begin
                        repeat

                        until Lines.Next = 0;
                    end;
                    Message('Lines disposed Successesfully');

                end;
            }
            action(Approvals)
            {
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                begin
                    DocType := Doctype::Disposal;
                    ApprovalEntries.SetRecordFilters(Database::"Disposal Plan Table Header", DocType, Rec."No.");
                    ApprovalEntries.Run;
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic;
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin

                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    Report.Run(Report::"Disposal Report", true, true, Rec);
                    Rec.Reset;
                end;
            }
        }
    }

    var
        ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TR,Disposal;
        DisposalLine: Record "Disposal Line";
        OTExists: Boolean;

    procedure UpdateControls()
    begin
    end;
}

