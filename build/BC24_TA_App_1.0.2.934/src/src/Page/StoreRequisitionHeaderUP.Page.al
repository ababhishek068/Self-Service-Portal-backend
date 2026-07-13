page 50860 "Store Requisition Header UP"
{
    PageType = Card;
    SourceTable = "Store Requistion Header";
    SourceTableView = WHERE(Status = FILTER(<> Posted));
    UsageCategory = Lists;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Editable = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Request date"; Rec."Request date")
                {
                    ApplicationArea = all;
                    editable = false;
                    ToolTip = 'Specifies the value of the Request date field.';
                }


                field("Required Date"; Rec."Required Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Required Date field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    trigger OnValidate()
                    begin
                        Dim1 := '';
                        DimRec.reset;
                        dimrec.setrange(Code, Rec."Global Dimension 1 Code");
                        if dimrec.find('-') then begin
                            Dim1 := DimRec.Name;
                            DimLabel1 := DimRec."Dimension Code";
                        end
                    end;
                }
                field("."; Dim1)
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Dim1 field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    trigger OnValidate()
                    begin
                        Dim2 := '';
                        DimRec.reset;
                        dimrec.setrange(Code, Rec."Shortcut Dimension 2 Code");
                        if dimrec.find('-') then begin
                            Dim2 := DimRec.Name;
                            DimLabel2 := DimRec."Dimension Code";
                        end
                    end;
                }
                field(".."; Dim2)
                {
                    ApplicationArea = all;
                    editable = false;
                    ToolTip = 'Specifies the value of the Dim2 field.';
                }

                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Caption = 'Section';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Section field.';
                    trigger OnValidate()
                    begin
                        Rec.Dim3 := '';
                        DimRec.reset;
                        dimrec.setrange(Code, Rec."Shortcut Dimension 3 Code");
                        if dimrec.find('-') then begin
                            Rec.Dim3 := DimRec.Name;
                            DimLabel3 := DimRec."Dimension Code";
                        end
                    end;
                }



                field("Request Description"; Rec."Request Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Request Description field.';
                }
                field("Issuing Store"; Rec."Issuing Store")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Issuing Store field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Requester ID"; Rec."Requester ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Requester ID field.';
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Employee No field.';
                }
                field(Status; Rec.Status)
                {
                    Editable = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    Caption = 'Posting Date';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Store Issue No";"Store Issue No"){
                    Editable=false;
                }
                field("Is Project"; Rec."Is Project")
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Is Project field.';
                }




            }

            group(Lines)
            {

                Caption = 'Lines';

                part(Control1; "Store Requisition Line UP")
                {
                    ApplicationArea = all;
                    SubPageLink = "Requistion No" = FIELD("No.");
                }
            }

        }
    }

    actions

    {
        area(Navigation)
        {
            action(ReqLines)
            {
                Caption = 'Lines';
                Image = Line;
                Promoted = true;
                ApplicationArea = all;
                RunObject = page "Store Requisition Line UP";
                RunPageLink = "Requistion No" = field("No.");
                ToolTip = 'Executes the Lines action.';
            }
        }
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Post Store Requisition")
                {
                    Caption = 'Post Store Requisition';
                    Image = Post;
                    Visible=false;
                    Promoted = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Post Store Requisition action.';
                    trigger OnAction()
                    begin

                        if not LinesExists then
                            Error('There are no Lines created for this Document');

                        if Rec.Status = Rec.Status::Posted then
                            Error('The Document Has Already been Posted');

                        if Rec.Status <> Rec.Status::Released then
                            Error('The Document Has not yet been Approved');



                        Rec.TestField("Issuing Store");
                        ReqLine.Reset;
                        ReqLine.SetRange(ReqLine."Requistion No", Rec."No.");
                        ReqLine.SetFilter(ReqLine."Quantity To Issue", '>%1', 0);
                        Rec.TestField("Issuing Store");
                        if ReqLine.Find('-') then begin
                            if InventorySetup.Get then begin
                                //  ERROR('1');
                                InventorySetup.TestField(InventorySetup."Items issue Template");
                                InventorySetup.TestField(InventorySetup."Items Issue Batch");
                                GenJnline.Reset;
                                GenJnline.SetRange(GenJnline."Journal Template Name", InventorySetup."Items issue Template");
                                GenJnline.SetRange(GenJnline."Journal Batch Name", InventorySetup."Items Issue Batch");
                                if GenJnline.Find('-') then GenJnline.DeleteAll;
                            end;
                            repeat
                            begin
                                //Issue
                                LineNo := LineNo + 1000;

                                GenJnline.Init;
                                GenJnline."Journal Template Name" := InventorySetup."Items issue Template";
                                GenJnline."Journal Batch Name" := InventorySetup."Items Issue Batch";
                                GenJnline."Line No." := LineNo;
                                GenJnline."Entry Type" := GenJnline."Entry Type"::"Negative Adjmt.";
                                GenJnline."Document No." := Rec."No.";
                                GenJnline."Item No." := ReqLine."No.";
                                GenJnline.Validate("Item No.");
                                GenJnline."Location Code" := Rec."Issuing Store";
                                GenJnline.Validate("Location Code");
                                GenJnline."Posting Date" := Rec."Request date";
                                GenJnline.Description := ReqLine.Description;
                                //GenJnline.Quantity:=ReqLine.Quantity;
                                GenJnline.Quantity := ReqLine."Quantity To Issue";
                                GenJnline."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                                GenJnline.Validate("Shortcut Dimension 1 Code");
                                GenJnline."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                                GenJnline.Validate("Shortcut Dimension 2 Code");
                                GenJnline.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                                GenJnline.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");
                                GenJnline.Validate(Quantity);
                                GenJnline.Validate("Unit Amount");
                                //GenJnline."Reason Code":='221';
                                //GenJnline.VALIDATE("Reason Code");
                                GenJnline.Insert(true);

                                ReqLine."Quantity Issued" := ReqLine."Quantity Issued" + ReqLine."Quantity To Issue";
                                ReqLine."Quantity To Issue" := 0;

                                if ReqLine."Quantity Issued" = ReqLine."Quantity Requested" then
                                    ReqLine."Request Status" := ReqLine."Request Status"::Closed;
                                ReqLine.Modify;
                            end;
                            until ReqLine.Next = 0;
                            //Post Entries
                            GenJnline.Reset;
                            GenJnline.SetRange(GenJnline."Journal Template Name", InventorySetup."Items issue Template");
                            //
                            GenJnline.SetRange(GenJnline."Journal Batch Name", InventorySetup."Items Issue Batch");
                            CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", GenJnline);
                            //End Post entries

                            Rec.CalcFields("Posted Count");                          //Modify All
                            if Rec."Posted Count" > 0 then begin
                                ReqLine.ModifyAll(ReqLine."Request Status", ReqLine."Request Status"::Closed);
                                Rec.Status := Rec.Status::Posted;
                                Rec.Modify;
                            end;
                        end;


                        /*     ReqLine.Reset;
                            ReqLine.SetRange(ReqLine."Requistion No", "No.");
                            if ReqLine.Find('-') then begin
                                repeat
                                begin
                                    if ReqLine."Quantity Issued" <> ReqLine."Quantity Requested" then
                                        if (Post = true) then
                                            Post := false;
                                end;
                                until ReqLine.Next = 0;
                            end;
                            if Post = true then begin
                                Status := Status::Posted;
                                Modify;
                            end; */

                    end;
                }
                separator(Separator1102755029) { }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ApplicationArea = Basic;
                    ToolTip = 'Executes the Approvals action.';
                    trigger OnAction()
                    var

                        AppEntry: Record "Approval Entry";
                        AppEntryPage: page "Approval Entries2";
                    begin
                        AppEntry.reset;
                        AppEntry.setrange("Document No.", Rec."No.");
                        if AppEntry.find('-') then begin
                            AppEntryPage.SetTableView(AppEntry);
                            AppEntryPage.Run();
                        end;
                    end;
                }
                action(sendApproval)
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Send A&pproval Request action.';

                    trigger OnAction()
                    var
                        State: Option Open,"Pending Approval",Cancelled,Approved;
                    begin
                        if not LinesExists then
                            Error('There are no Lines created for this Document');

                        State := State::Open;
                        if Rec.Status <> Rec.Status::Released then State := State::Open;
                        Rec.TestField("Responsibility Center");
                        /* DocType:=DocType::Requisition;
                         CLEAR(tableNo);
                         tableNo:=DATABASE::"Store Requistion Header";
                         ApprovalMgt.SendApproval(tableNo,Rec."No.",DocType,State,'',"Responsibility Center");*/
                        //    ApprovalMgt.SendApproval(Table_id,Doc_No,Doc_Type,Status,WebUser)

                        VarVariant := Rec;
                        if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                            CustomApprovals.OnSendDocForApproval(VarVariant);

                    end;
                }
                action(cancellsApproval)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';

                    trigger OnAction()
                    begin
                        /* DocType:=DocType::Requisition;
                         showmessage:=TRUE;
                         ManualCancel:=TRUE;
                         CLEAR(tableNo);
                         tableNo:=DATABASE::"Store Requistion Header";
                          IF ApprovalMgt.CancelApproval(tableNo,DocType,Rec."No.",showmessage,ManualCancel) THEN;*/

                        VarVariant := Rec;
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);

                    end;
                }
                separator(Separator1102755035) { }
                action("Store Requisition Voucher")
                {
                    Caption = 'Store Requisition Voucher';
                    Image = PreviewChecks;
                    Promoted = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Print/Preview action.';

                    trigger OnAction()
                    var
                        SRN: report "Store Requisition";
                        SRNRec: Record "Store Requistion Header";
                    begin
                        SRNRec.Reset;
                        SRNRec.SetFilter(SRNRec."No.", Rec."No.");
                        if SRNRec.Find('-') then begin
                            SRN.SetTableView(SRNRec);
                            SRN.run();
                        end;
                        // REPORT.Run(70135450, true, true, SRNRec);
                    end;
                }
                separator(Separator1102755044) { }
            }
        }
    }



    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //"Responsibility Center" := UserMgt.GetPurchasesFilter();
        //Add dimensions if set by default here
        Rec."Global Dimension 1 Code" := UserMgt.GetSetDimensions(UserId, 1);
        Rec.Validate("Global Dimension 1 Code");
        Rec."Shortcut Dimension 2 Code" := UserMgt.GetSetDimensions(UserId, 2);
        Rec.Validate("Shortcut Dimension 2 Code");
        Rec."Shortcut Dimension 3 Code" := UserMgt.GetSetDimensions(UserId, 3);
        Rec.Validate("Shortcut Dimension 3 Code");
        Rec."Shortcut Dimension 4 Code" := UserMgt.GetSetDimensions(UserId, 4);
        Rec.Validate("Shortcut Dimension 4 Code");
        Rec."Responsibility Center" := 'MAIN';
        Rec."User ID" := UserId;
        Rec."Request date" := today;

    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FilterGroup(0);
        end;
        UpdateControls;
    end;

    var
        UserMgt: Codeunit "User Setup Management BR";
        //  ApprovalMgt: Codeunit "Approvals Management";
        ReqLine: Record "Store Requistion Lines";
        InventorySetup: Record "Cash Office Setup";
        GenJnline: Record "Item Journal Line";
        LineNo: Integer;
        HasLines: Boolean;
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
        DimRec: Record "Dimension Value";
        Dim1: Text[200];
        DimLabel1: Text[200];
        DimLabel2: Text[200];
        DimLabel3: Text[200];
        Dim2: Text[200];

    procedure LinesExists(): Boolean
    var
        PayLines: Record "Store Requistion Lines";
    begin
        HasLines := false;
        PayLines.Reset;
        PayLines.SetRange(PayLines."Requistion No", Rec."No.");
        if PayLines.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;

    procedure UpdateControls()
    begin

        /* IF Status<>Status::Released THEN BEGIN
         CurrForm."Issue Date".EDITABLE:=FALSE;
         CurrForm.UPDATECONTROLS();
             END ELSE BEGIN
         CurrForm."Issue Date".EDITABLE:=TRUE;
         CurrForm.UPDATECONTROLS();
         END;
            IF Status=Status::Open THEN BEGIN
         CurrForm."Global Dimension 1 Code".EDITABLE:=TRUE;
         CurrForm."Request date" .EDITABLE:=TRUE;
         CurrForm."Responsibility Center" .EDITABLE:=TRUE;
         CurrForm."Issuing Store" .EDITABLE:=TRUE;

         CurrForm."Request Description".EDITABLE:=TRUE;
         CurrForm."Shortcut Dimension 2 Code".EDITABLE:=TRUE;
         CurrForm."Request Description".EDITABLE:=TRUE;
         CurrForm."Shortcut Dimension 3 Code".EDITABLE:=TRUE;
         CurrForm."Shortcut Dimension 4 Code".EDITABLE:=TRUE;
         CurrForm."Required Date".EDITABLE:=TRUE;
         CurrForm.UPDATECONTROLS();
         END ELSE BEGIN
         CurrForm."Responsibility Center".EDITABLE:=FALSE;
         CurrForm."Global Dimension 1 Code".EDITABLE:=FALSE;
         CurrForm."Request Description".EDITABLE:=FALSE;
         CurrForm."Shortcut Dimension 2 Code".EDITABLE:=FALSE;
         CurrForm."Required Date".EDITABLE:=FALSE;
         CurrForm."Shortcut Dimension 3 Code".EDITABLE:=FALSE;
         CurrForm."Shortcut Dimension 4 Code".EDITABLE:=FALSE;
         CurrForm."Required Date".EDITABLE:=FALSE;
          CurrForm."Request date".EDITABLE:=FALSE;
         CurrForm.UPDATECONTROLS();
         END
         */

    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;
}

