namespace Hijra.Hijra;
using Microsoft.Foundation.Attachment;

codeunit 50050 "Custom Document Attachment"
{
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure SpecifyCustomRecordOnBeforeDrilldown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        applicantRegister: Record "Applicant Register";
        hrEmployee: Record "HR-Employee";
        hrCommittee: Record "HR Committees";
        HRDisciplinaryCases: Record "HR Disciplinary Cases";
        ExitRequisition: Record "HR Employee Exit Interviews";
        jobApplicants: Record "HR Job Applicants";
        leaveApplication: Record "HR Leave Application";
        Meeting: Record Meetings;
        HrDocumentDownloads: Record "Hr Document Downloads";
    begin
        case
            DocumentAttachment."Table ID" of
            Database::"HR-Employee":
                begin
                    RecRef.Open(Database::"HR-Employee");
                    if hrEmployee.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(hrEmployee);
                end;
            Database::"HR Leave Application":
                begin
                    RecRef.Open(Database::"HR Leave Application");
                    if leaveApplication.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(leaveApplication);
                end;
            Database::"Applicant Register":
                begin
                    RecRef.Open(Database::"Applicant Register");
                    if applicantRegister.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(applicantRegister);
                end;
            Database::"HR Job Applicants":
                begin
                    RecRef.Open(Database::"HR Job Applicants");
                    if jobApplicants.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(jobApplicants);
                end;
            Database::"HR Committees":
                begin
                    RecRef.Open(Database::"HR Committees");
                    if hrCommittee.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(hrCommittee);
                end;
            Database::Meetings:
                begin
                    RecRef.Open(Database::Meetings);
                    if Meeting.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(Meeting);
                end;
            Database::"HR Employee Exit Interviews":
                begin
                    RecRef.Open(Database::"HR Employee Exit Interviews");
                    if ExitRequisition.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(ExitRequisition);
                end;
            Database::"HR Disciplinary Cases":
                begin
                    RecRef.Open(Database::"HR Disciplinary Cases");
                    if HRDisciplinaryCases.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(HRDisciplinaryCases);
                end;
            Database::"Hr Document Downloads":            
                begin
                    RecRef.Open(Database::"Hr Document Downloads");
                    if HrDocumentDownloads.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(HrDocumentDownloads);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure SpecifyFieldAssociatedONAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        fRef: FieldRef;
        RecNo: Code[30];
    begin
        case RecRef.Number of
            Database::"HR-Employee":
                begin
                    fRef := RecRef.Field(1);
                    RecNo := fRef.Value();
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            Database::"HR Leave Application":
                begin
                    fRef := RecRef.Field(1);
                    RecNo := fRef.Value();
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            Database::"Applicant Register":
                begin
                    fRef := RecRef.Field(26);
                    RecNo := fRef.Value();
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            Database::"HR Job Applicants":
                begin
                    fRef := RecRef.Field(1);
                    RecNo := fRef.Value();
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            Database::"HR Committees":
                begin
                    fRef := RecRef.Field(1);
                    RecNo := fRef.Value();
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            Database::Meetings:
                begin
                    fRef := RecRef.Field(1);
                    RecNo := fRef.Value();
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            Database::"HR Employee Exit Interviews":
                begin
                    fRef := RecRef.Field(1);
                    RecNo := fRef.Value();
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            Database::"HR Disciplinary Cases":
                begin
                    fRef := RecRef.Field(1);
                    RecNo := fRef.Value();
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            Database::"Hr Document Downloads":
                begin
                    fRef := RecRef.Field(1);
                    RecNo := fRef.Value();
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure UpdatePrimaryKeyOnAfterInitFieldsfromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        fieldRef: FieldRef;
        recNo: code[30];
    begin
        case RecRef.Number of
            Database::"HR-Employee":
                begin
                    fieldRef := RecRef.Field(1);
                    recNo := fieldRef.Value();
                    DocumentAttachment.Validate("No.", recNo);
                end;
            Database::"HR Leave Application":
                begin
                    fieldRef := RecRef.Field(1);
                    recNo := fieldRef.Value();
                    DocumentAttachment.Validate("No.", recNo);
                end;
            Database::"Applicant Register":
                begin
                    fieldRef := RecRef.Field(26);
                    recNo := fieldRef.Value();
                    DocumentAttachment.Validate("No.", recNo);
                end;
            Database::"HR Job Applicants":
                begin
                    fieldRef := RecRef.Field(1);
                    recNo := fieldRef.Value();
                    DocumentAttachment.Validate("No.", recNo);
                end;
            Database::"HR Committees":
                begin
                    fieldRef := RecRef.Field(1);
                    recNo := fieldRef.Value();
                    DocumentAttachment.Validate("No.", recNo);
                end;
            Database::"HR Employee Exit Interviews":
                begin
                    fieldRef := RecRef.Field(1);
                    recNo := fieldRef.Value();
                    DocumentAttachment.Validate("No.", recNo);
                end;
            Database::"HR Disciplinary Cases":
                begin
                    fieldRef := RecRef.Field(1);
                    recNo := fieldRef.Value();
                    DocumentAttachment.Validate("No.", recNo);
                end;
            Database::"Hr Document Downloads":
                begin
                    fieldRef := RecRef.Field(1);
                    recNo := fieldRef.Value();
                    DocumentAttachment.Validate("No.", recNo);
                end;
        end;
    end;    
}
