page 50730 "Store Req Header Approved"
{
    PageType = Card;
    SourceTable = "Store Requistion Header";
    SourceTableView = WHERE(Status = FILTER(Released));
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
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Request date"; Rec."Request date")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Request date field.';

                }


                field("Required Date"; Rec."Required Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Required Date field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }

                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }

                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {

                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }


                field("Request Description"; Rec."Request Description")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Request Description field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Requester ID"; Rec."Requester ID")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Requester ID field.';
                }
                field("Employee No"; Rec."Employee No")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Employee No field.';
                }
                field("Issuing Store"; Rec."Issuing Store")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Issuing Store field.';
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    Caption = 'Posting Date';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field(Post;Post){}

                field("Store Issue No";"Store Issue No"){}
                
                


            }

            group(Lines)
            {

                Caption = 'Lines';

                part(Control1; "Store Req Line Approved")
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
                    Promoted = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Post Store Requisition action.';
                    trigger OnAction()
                    var
                    gentag: Boolean;
                    tagcode:code[20];
                    cat: code[20];
                    subcat: code[20];
                    no: Code[20];
                    fixedasset: Record "Fixed Asset";
                    begin

                        if not LinesExists then
                            Error('There are no Lines created for this Document');

                        if Rec.Status = Rec.Status::Posted then
                            Error('The Document Has Already been Posted');

                        if Rec.Status <> Rec.Status::Released then
                            Error('The Document Has not yet been Approved');

                             //test asset
                             ReqLine.Reset();
                             ReqLine.SetRange(ReqLine."Requistion No",rec."No.");
                             if ReqLine.Find('-') then begin
                                repeat
                             if (ReqLine.Type=ReqLine.Type::Asset) and (ReqLine."Tag No"='')then begin
                                //check item category;
                                fixedasset.Reset();
                                fixedasset.SetRange(fixedasset."No.",ReqLine."No.");
                                if fixedasset.FindFirst() then begin
                                    fixedasset.TestField("Item Category Code");
                                    fixedasset.TestField("Item Sub-Category");
                                    cat:=fixedasset."Item Category Code";
                                    subcat:=fixedasset."Item Sub-Category";
                                    //Message(cat);
                                    //Message(subcat);
                                    if fixedasset."Asset Tag"<>'' then begin
                                        if fixedasset."Assigned Employee"<>'' then begin
                                            Error('Asset already allocated to '+fixedasset."Assigned Employee"+' use transfer method instead');
                                        end;

                                    end;
                                end;

                                gentag:=Confirm('Are you sure you want to issue this asset to employee location/department');
                                if gentag=true then begin
                                    TestField("Employee No");
                                    hremps.Reset();
                                    hremps.SetRange(hremps."No.","Employee No");
                                    hremps.SetRange(hremps.Status,hremps.Status::Active);
                                    if hremps.FindFirst() then begin
                                        if (hremps."Business Unit"<>'') and (hremps."Global Dimension 3 Code"<>'') then begin
                                            branches.Reset();
                                            branches.SetRange(branches."Division/Branch Code",hremps."Global Dimension 3 Code");
                                            branches.SetRange(branches.level,branches.level::Branch);
                                            if branches.FindFirst() then begin
                                                tagcode:=branches."Division/Branch Code";
                                            end;

                                        end else if (hremps."Business Unit"<>'') and (hremps."Global Dimension 3 Code"='') then begin
                                            distrdepart.Reset();
                                            distrdepart.SetRange(distrdepart."Department Code",hremps."Business Unit");
                                            distrdepart.SetRange(distrdepart.level,distrdepart.level::District);
                                            if distrdepart.FindFirst() then begin
                                                tagcode:=distrdepart."Department Code";
                                            end;

                                        end else if hremps."Global Dimension 2 Code"<>'' then begin
                                            distrdepart.Reset();
                                            distrdepart.SetRange(distrdepart."Department Code",hremps."Business Unit");
                                            distrdepart.SetRange(distrdepart.level,distrdepart.level::Department);
                                            if distrdepart.FindFirst() then begin
                                                tagcode:=distrdepart."Department Code";
                                            end;

                                            //Message('1'+tagcode);

                                        end else begin
                                            Error('This employee is not allocated District/Branch/Department');
                                        end;


                                    end else begin
                                        Error('This employee does not exist in HR records');
                                    end;
                                    //Message('2'+tagcode);

                                   


                                end else begin
                                    Error('You cannot issue the item without tag');
                                end;
                                //create tag.
                                itemsubcat.Reset();
                                itemsubcat.SetRange(itemsubcat."Item Category",cat);
                                itemsubcat.SetRange(itemsubcat."Item Sub Category",subcat);
                                if itemsubcat.FindFirst() then
                               itemsubcat.TestField(itemsubcat."Number sequence");
                               no:=NoSeriesMgt.GetNextNo(itemsubcat."Number sequence", Today, true);
                               //Error(no);
                               ReqLine."Tag No":='HB/'+tagcode+'/'+cat+'/'+subcat+'/'+no+'/'+format(Date2DMY(Today,3));
                               ReqLine.Validate("Tag No");
                            if fixedasset.Get(ReqLine."No.") then begin
                                fixedasset."Asset Tag":=ReqLine."Tag No";
                                fixedasset.Modify;
                            end;

                            
                                //

                            end;
                            ReqLine.Modify;
                            until ReqLine.Next=0;
                            
                             end;            









                    //end




                    //felix enable


                        Rec.TestField("Issuing Store");
                        ReqLine.Reset;
                        ReqLine.SetRange(ReqLine."Requistion No", Rec."No.");
                        ReqLine.SetFilter(ReqLine."Quantity To Issue", '>%1', 0);
                        ReqLine.SetRange(ReqLine.Type,ReqLine.Type::Item);
                        Rec.TestField("Issuing Store");
                        if ReqLine.Find('-') then begin                      //Issue tag
                            


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
                            if Rec."Posted Count" > 0 then Post := true;
                            //Post := JournlPosted.PostedSuccessfully();
                            if Post then
                                ReqLine.ModifyAll(ReqLine."Request Status", ReqLine."Request Status"::Closed);

                        end;


                        ReqLine.Reset;
                        ReqLine.SetRange(ReqLine."Requistion No", Rec."No.");
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
                            Rec.Status := Rec.Status::Posted;
                            Rec.Modify;
                        end;

                        if "Store Issue No" = '' then begin
            InventorySetup.Get();
            InventorySetup.TestField(InventorySetup."Store Issuance Nos");
            "Store Issue No":=NoSeriesMgt.GetNextNo(InventorySetup."Store Issuance Nos", 0D, true);
        end;

               

                   

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
                    begin
                        /*DocumentType:=DocumentType::Requisition;
                        ApprovalEntries.SetRecordFilters(DATABASE::"Store Requistion Header",DocumentType,"No.");
                        ApprovalEntries.RUN;
                        */
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);

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
                    Caption = 'Store Issuance Voucher';
                    Image = PreviewChecks;
                    Promoted = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Print/Preview action.';
               
                    trigger OnAction()
                    var
                    SRN: report "Store Issue";
                    SRNRec: Record "Store Requistion Header";
                   
                    begin
                        if "Store Issue No"<>'' then begin
                            if "Store Issue No" = '' then begin
            InventorySetup.Get();
            InventorySetup.TestField(InventorySetup."Store Issuance Nos");
            "Store Issue No":=NoSeriesMgt.GetNextNo(InventorySetup."Store Issuance Nos", 0D, true);
        end;

                        end;
                       // TestField(Post);
                        SRNRec.Reset;
                        SRNRec.SetFilter(SRNRec."No.", Rec."No.");
                        if SRNRec.Find('-') then begin
                            SRN.SetTableView(SRNRec);
                            SRN.run();
                        end;
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
        NoSeriesMgt: Codeunit "No. Series";
        GenJnline: Record "Item Journal Line";
        LineNo: Integer;
        Post: Boolean;
        HasLines: Boolean;
        SRNRec: Record "Store Requistion Header";
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
        hremps: Record "HR-Employee";
        distrdepart: Record Departments;
        branches: Record Branches;
        fixedassets: Record "Fixed Asset";
        itemcat: Record "Item Category";
        itemsubcat: Record "Item Subcategory";

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

