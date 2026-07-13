page 50491 "Minor Asset Requisition"
{
    PageType = Document;
    SourceTable = "Store Requistion Header";
    SourceTableView = WHERE(Status = FILTER(<> Posted), "Requisition Type" = filter("Minor Assets"));
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
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    Caption = 'Posting Date';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }


            }
            group(Lines)
            {

                Caption = 'Lines';

                part(Control1; "Minor Assets Issue and Returns")
                {
                    ApplicationArea = all;
                    SubPageLink = "Requisition No." = FIELD("No.");
                }
            }


        }

    }

    actions

    {

        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Post Store Requisition")
                {
                    Caption = 'Post Requisition';
                    Image = Post;
                    Promoted = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Post Requisition action.';
                    trigger OnAction()
                    begin

                        if Rec.Status <> Rec.Status::Released then
                            Error('The Document Has not yet been Approved');

                        Rec.TestField("Issuing Store");

                        Rec.Status := Rec.Status::Posted;
                        Rec.Modify;

                    end;





                }
                separator(Separator1102755029) { }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        RecID: RecordID;
                        FromRecRef: RecordRef;
                        DocDetails: Record "Store Requistion Header";
                    begin
                        DocDetails.Reset();
                        DocDetails.SetRange("No.", Rec."No.");
                        if DocDetails.Find('-') then begin
                            FromRecRef.GETTABLE(DocDetails);
                            RecID := FromRecRef.RecordId;
                            ApprovalsMgmt.OpenApprovalEntriesPage(RecID);
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
                action("Print/Preview")
                {
                    Caption = 'Print/Preview';
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

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Requisition Type" := Rec."Requisition Type"::"Minor Assets";
    end;
}

