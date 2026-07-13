Codeunit 50039 "QMS Webportal"
{

    trigger OnRun()
    begin
    
    end;

    var
        NextNo: Code[20];
        NoSeriesMgt: Codeunit "No. Series";
        RecordLink: Record "Record Link";
        filename: Text;
        AuditProgramme: Record "Audit Programmes";
        Audits: Record Audits;
        Auditors: Record Auditors;
        Checklists: Record "Audit Checklists";
        AuditMeetings: Record "Audit Meetings";
        MeetingAgenda: Record "Audit Meetings Agenda List";
        MeetingAttendance: Record "Audit Meetings Attendance";
        AuditFinding: Record "Audit Checklists";
        AuditFindingAction: Record "Audit Findings Actions";
        AuditNotifications: Record "Audit Notifications";
        CompanyName: label 'Jaramogi Oginga Odinga University of Science and Technology';
        AuditCheckpoint: Record "Audit Checklists";
        Risks: Record Risks;
        RiskControls: Record "Risk Controls";
        RiskMitigations: Record "Risk Mitigations";
        ResidualRisks: Record "Residual Risks";
        RiskIncidences: Record "Risk Incidences";
        QMSArchive: Record "QMS Archive";
        AuditReport: Report "Audit Report - Departments";
        AuditorReport: report "Auditor Report";
        RiskReport: Report "Inherent Risks";
        DimensionValues: Record "Dimension Value";

    procedure NewAuditProgramme(title: Text[100]; comment: Text[200]; createdBy: Text[50]) return_value: Code[20]
    begin
        return_value := '';
        AuditProgramme.Reset;
        AuditProgramme.Init;
        NextNo := NoSeriesMgt.GetNextNo('AUDTP', 0D, true);
        AuditProgramme.Code := NextNo;
        AuditProgramme.Title := title;
        AuditProgramme."Description/Comment" := comment;
        AuditProgramme."Date Created" := Today;
        AuditProgramme."Created By" := createdBy;
        AuditProgramme.Status := AuditProgramme.Status::"Pending Approval";
        AuditProgramme.Insert;
        return_value := NextNo;
    end;

    procedure EditAuditProgramme(progCode: Code[30]; title: Text[100]; comment: Text[200]; editedBy: Text[50]) return_value: Boolean
    begin
        return_value := false;
        AuditProgramme.Reset;
        AuditProgramme.SetRange(Code, progCode);
        if AuditProgramme.Find('-') then begin
            AuditProgramme.Title := title;
            AuditProgramme."Description/Comment" := comment;
            AuditProgramme."Date Edited" := Today;
            AuditProgramme."Last Edited By" := editedBy;
            AuditProgramme.Modify;
            return_value := true;
        end
        else begin
            Error('Unknown audit programme');
        end;
    end;

    procedure DeleteAuditProgramme(progCode: Code[30]) return_value: Boolean
    begin
        return_value := false;
        AuditProgramme.Reset;
        AuditProgramme.SetRange(Code, progCode);
        if AuditProgramme.Find('-') then begin
            AuditProgramme.Delete;
            return_value := true;
        end
        else begin
            Error('Unknown audit programme');
        end;
    end;

    procedure UpdateAudit(auditCode: Code[20]; auditDateFrom: Date; auditDateTo: Date; leadersDate: Date; membersDate: Date; followDateFrom: Date; followDateTo: Date; reviewDateFrom: Date; reviewDateTo: Date; editedBy: Text; auditProgramme: Code[20]) return_value: Boolean
    begin
        if Format(auditDateFrom)<> '01/01/1753' then auditDateFrom := auditDateFrom else auditDateFrom := 0D;
        if Format(auditDateTo)<> '01/01/1753' then auditDateTo := auditDateTo else auditDateTo := 0D;
        if Format(membersDate)<> '01/01/1753' then membersDate := membersDate else membersDate := 0D;
        if Format(leadersDate)<> '01/01/1753' then leadersDate := leadersDate else leadersDate := 0D;
        if Format(followDateFrom)<> '01/01/1753' then followDateFrom := followDateFrom else followDateFrom := 0D;
        if Format(followDateTo)<> '01/01/1753' then followDateTo := followDateTo else followDateTo := 0D;
        if Format(reviewDateFrom)<> '01/01/1753' then reviewDateFrom := reviewDateFrom else reviewDateFrom := 0D;
        if Format(reviewDateTo) <> '01/01/1753' then reviewDateTo := reviewDateTo else reviewDateTo := 0D;
        return_value := false;
        Audits.Reset;
        Audits.SetRange(Code, auditCode);
        if Audits.Find('-') then begin
            Audits."Audit Programme" := auditProgramme;
            Audits."Audit From Date" := auditDateFrom;
            Audits."Audit To Date" := auditDateTo;
            Audits."Members Appointment Date" := membersDate;
            Audits."Leaders Appointment Date" := leadersDate;
            Audits."Follow Up From Date" := followDateFrom;
            Audits."Follow Up To Date" := followDateTo;
            Audits."Review From Date" := reviewDateFrom;
            Audits."Review To Date" := reviewDateTo;
            Audits.Modify;
            return_value := true;
        end;
    end;

    procedure NewAuditor(userId: Code[30]; role: Integer; editedBy: Text[100]; department: Code[50]; auditCode: Code[30]; programmeCode: Code[30]) return_value: Code[30]
    begin
        return_value := '';
        Auditors.Reset;
        Auditors.SetRange("Audit Code", auditCode);
        Auditors.SetRange("User ID", userId);
        if Auditors.Find('-') then begin
            return_value := '';
        end
        else begin
            Auditors.Reset;
            Auditors.Init;
            NextNo := NoSeriesMgt.GetNextNo('AUDTOR', 0D, true);
            Auditors.Code := NextNo;
            Auditors."Audit Code" := auditCode;
            Auditors."Audit Programme" := programmeCode;
            Auditors."User ID" := userId;
            //Auditors."Audit No.":=auditNo;
            Auditors.Role := role;
            Auditors.Department := department;
            Auditors."Date Created" := Today;
            Auditors."User ID" := userId;
            Auditors.Status := Auditors.Status::"Pending Approval";
            Auditors.Insert;
            return_value := NextNo;
        end;
    end;

    procedure DeleteAuditor(auditorCode: Code[30]) return_value: Boolean
    begin
        return_value := false;
        Auditors.SetRange(Code, auditorCode);
        if Auditors.Find('-') then begin
            Auditors.Delete;
            return_value := true;
        end;
    end;

    procedure InsertAuditDocument(auditProgramme: Code[10]; auditNo: Integer; url: Text[150]; description: Text[150]; auditCode: Code[30]) return_value: Boolean
    var
        RecordID: RecordID;
    begin
        return_value := false;
        Audits.Reset;
        Audits.SetRange(Code, auditCode);
        Audits.SetRange("Audit Programme", auditProgramme);
        Audits.SetRange("Audit No.", auditNo);
        if Audits.Find('-') then begin
            if Exists(url) then
                Erase(url);
            RecordLink.Init;
            RecordID := Audits.RecordId;
            RecordLink."Record ID" := RecordID;
            RecordLink.URL1 := url;
            RecordLink.Description := description;
            RecordLink."User ID" := UserId;
            RecordLink.Company := 'UNIVERSITY';
            RecordLink.Created := CurrentDatetime;
            RecordLink.Insert(true);
            return_value := true;
        end;
    end;

    procedure AuditDocPreview(filename: Text[100]) return_value: Boolean
    var
        filepath: Text[200];
        GenSetup: Record "General Set-Up";
    begin
        return_value := false;
        GenSetup.get;
        GenSetup.TestField("Portal Attachment File Path");
        filepath := GenSetup."Portal Attachment File Path" + filename;
        if Exists(filepath) then begin
            return_value := true;
        end;
    end;

    procedure ChecklistPoint(auditCode: Code[30]; description1: Text[250]; description2: Text[250]; description3: Text[250]; description4: Text[250]; clause: Text[200]; createdBy: Code[100]; actionType: Text; checkpointCode: Code[30]; department: Code[20]) return_value: Boolean
    begin
        return_value := false;
        Checklists.Reset;
        if actionType = 'add' then begin
            Checklists.Init;
            NextNo := NoSeriesMgt.GetNextNo('AUDTCK', 0D, true);
            Checklists.Code := NextNo;
            Checklists."Audit Code" := auditCode;
            Checklists."Checkpoint Desc 1" := description1;
            Checklists."Checkpoint Desc 3" := description2;
            Checklists."Checkpoint Desc 4" := description3;
            Checklists."Checkpoint Desc 2" := description4;
            Checklists."Clause of Criteria Document" := clause;
            Checklists."Date Created" := Today;
            Checklists."Created By" := createdBy;
            Checklists.Department := department;
            Checklists.Insert;
            return_value := true;
        end
        else
            if actionType = 'edit' then begin
                Checklists.SetRange(Code, checkpointCode);
                if Checklists.Find('-') then begin
                    Checklists."Audit Code" := auditCode;
                    Checklists."Checkpoint Desc 1" := description1;
                    Checklists."Checkpoint Desc 3" := description2;
                    Checklists."Checkpoint Desc 4" := description3;
                    Checklists."Checkpoint Desc 2" := description4;
                    Checklists."Clause of Criteria Document" := clause;
                    Checklists.Department := department;
                    Checklists.Modify;
                    return_value := true;
                end;
            end;
    end;

    procedure DeleteChecklistPoint("code": Code[10]) return_value: Boolean
    begin
        return_value := false;
        Checklists.Reset;
        Checklists.SetRange(Code, code);
        if Checklists.Find('-') then
            Checklists.Delete;
        return_value := true;
    end;

    procedure NewAuditx(auditNo: Integer; auditProgramme: Code[30]) return_value: Boolean
    begin
        return_value := false;
        Audits.Reset;
        Audits.SetRange("Audit No.", auditNo);
        Audits.SetRange("Audit Programme", auditProgramme);
        if Audits.Find('-') then begin
            return_value := false;
        end
        else begin
            Audits.Init;
            NextNo := NoSeriesMgt.GetNextNo('AUDT', 0D, true);
            Audits.Code := NextNo;
            Audits."Audit Programme" := auditProgramme;
            Audits."Audit No." := auditNo;
            Audits.Status := Audits.Status::Open;
            Audits."Date Created" := Today;
            Audits.Insert;
            return_value := true;
        end;
    end;

    procedure AuditMeeting(meetingCode: Code[20]; auditCode: Code[20]; description1: Text[250]; description2: Text[250]; category: Integer; meetingDate: Date; createdBy: Code[30]; actionType: Text[10]) return_value: Boolean
    begin
        return_value := false;
        AuditMeetings.Reset;
        if actionType = 'new' then begin
            AuditMeetings.Init;
            NextNo := NoSeriesMgt.GetNextNo('AUDTMT', 0D, true);
            AuditMeetings.Code := NextNo;
            AuditMeetings."Description 1" := description1;
            AuditMeetings."Description 2" := description2;
            AuditMeetings.Category := category;
            AuditMeetings."Audit Code" := auditCode;
            AuditMeetings."Meeting Date" := meetingDate;
            AuditMeetings."Date Created" := Today;
            AuditMeetings."Created By" := createdBy;
            AuditMeetings.Insert;
            return_value := true;
        end
        else
            if actionType = 'edit' then begin
                AuditMeetings.SetRange(Code, meetingCode);
                if AuditMeetings.Find('-') then begin
                    AuditMeetings."Description 1" := description1;
                    AuditMeetings."Description 2" := description2;
                    AuditMeetings.Category := category;
                    AuditMeetings."Audit Code" := auditCode;
                    AuditMeetings."Meeting Date" := meetingDate;
                    AuditMeetings.Modify;
                    return_value := true;
                end;
            end;
    end;

    procedure DeleteAuditMeeting(meetingCode: Code[10]) return_value: Boolean
    begin
        return_value := false;
        AuditMeetings.Reset;
        AuditMeetings.SetRange(Code, meetingCode);
        if AuditMeetings.Find('-') then begin
            AuditMeetings.Delete;
            return_value := true;
        end;
    end;

    procedure AuditMeetingAgenda(agendaCode: Code[20]; description1: Text[250]; description2: Text[250]; createdBy: Code[30]; actionType: Text[10]; meetingCode: Code[30]) return_value: Boolean
    begin
        return_value := false;
        MeetingAgenda.Reset;
        if actionType = 'new' then begin
            MeetingAgenda.Init;
            NextNo := NoSeriesMgt.GetNextNo('AUDTAG', 0D, true);
            MeetingAgenda.Code := NextNo;
            MeetingAgenda."Meeting Code" := meetingCode;
            MeetingAgenda."Agenda Desc 1" := description1;
            MeetingAgenda."Agenda Desc 2" := description2;
            MeetingAgenda."Date Created" := Today;
            MeetingAgenda."Created By" := createdBy;
            MeetingAgenda.Insert;
            return_value := true;
        end
        else
            if actionType = 'edit' then begin
                MeetingAgenda.SetRange(Code, agendaCode);
                if MeetingAgenda.Find('-') then begin
                    MeetingAgenda."Agenda Desc 1" := description1;
                    MeetingAgenda."Agenda Desc 2" := description2;
                    MeetingAgenda."Date Edited" := Today;
                    MeetingAgenda."Edited By" := createdBy;
                    MeetingAgenda.Modify;
                    return_value := true;
                end;
            end;
    end;

    procedure DeleteAuditMeetingAgenda(agendaCode: Code[20]) return_value: Boolean
    begin
        return_value := false;
        MeetingAgenda.Reset;
        MeetingAgenda.SetRange(Code, agendaCode);
        if MeetingAgenda.Find('-') then begin
            MeetingAgenda.Delete;
            return_value := true;
        end;
    end;

    procedure AuditMeetingAttendee(meetingCode: Code[30]; createdBy: Code[30]; attendeeCode: Code[30]) return_value: Boolean
    begin
        return_value := false;
        AuditMeetings.Reset;
        AuditMeetings.Init;
        NextNo := NoSeriesMgt.GetNextNo('AUDTAT', 0D, true);
        MeetingAttendance.Code := NextNo;
        MeetingAttendance."Meeting Code" := meetingCode;
        MeetingAttendance.Attendee := attendeeCode;
        MeetingAttendance."Date Created" := Today;
        MeetingAttendance."Created By" := createdBy;
        MeetingAttendance.Insert;
        return_value := true;
    end;

    procedure DeleteAuditMeetingAttendee(attendanceCode: Code[10]) return_value: Boolean
    begin
        return_value := false;
        MeetingAttendance.Reset;
        MeetingAttendance.SetRange(Code, attendanceCode);
        if MeetingAttendance.Find('-') then begin
            MeetingAttendance.Delete;
            return_value := true;
        end;
    end;

    procedure CorrectiveActionForm(findingActionCode: Code[20]; actionClassification: Integer; findingClassification: Integer; type: Text; findingCode: Code[20]; reviewArea: Text[250]; requirement1: Text[250]; requirement2: Text[250]; evidence1: Text[250]; evidence2: Text[250]; evidence3: Text[250]; rootCause: Text[250]; correction1: Text[250]; correction2: Text[250]; correction3: Text[250]; correction4: Text[250]; recurrence1: Text[250]; recurrence2: Text[250]; completionDate: Date; isAppropriate: Boolean; followUpAction: Text[250]; followUpStatus: Integer; isEffective: Boolean; effectivenessDesc: Text[250]; effectivenessStatus: Boolean) return_value: Boolean
    begin
        return_value := false;
        AuditFinding.Reset;
        AuditFinding.SetRange(Code, findingCode);
        if AuditFinding.Find('-') then begin
            AuditFinding.Classification := findingClassification;
            AuditFinding.Modify;
            if (AuditFinding.Classification) <> (AuditFinding.Classification::"Compliance/Positive") then begin
                AuditFindingAction.Reset;
                if type = 'new' then begin
                    AuditFindingAction.Init;
                    NextNo := NoSeriesMgt.GetNextNo('AUDTFA', 0D, true);
                    AuditFindingAction.Code := NextNo;
                    AuditFindingAction."Finding Code" := findingCode;
                    AuditFindingAction."Action Classification" := actionClassification;
                    AuditFindingAction."Review Area" := reviewArea;
                    AuditFindingAction."Requirement Desc 1" := requirement1;
                    AuditFindingAction."Requirement Desc 2" := requirement2;
                    AuditFindingAction."Evidence Desc 1" := evidence1;
                    AuditFindingAction."Evidence Desc 2" := evidence2;
                    AuditFindingAction."Evidence Desc 3" := evidence3;
                    AuditFindingAction."Root Cause" := rootCause;
                    AuditFindingAction."Correction Desc 1" := correction1;
                    AuditFindingAction."Correction Desc 2" := correction2;
                    AuditFindingAction."Correction Desc 3" := correction3;
                    AuditFindingAction."Correction Desc 4" := correction4;
                    AuditFindingAction."Recurrence action 1" := recurrence1;
                    AuditFindingAction."Recurrence action 2" := recurrence2;
                    if Format(completionDate) <> '01/01/1753' then completionDate := completionDate else completionDate := 0D;
                    AuditFindingAction."Completion Date" := completionDate;
                    AuditFindingAction."Action Appropriate?" := isAppropriate;
                    AuditFindingAction."Follow Up Action" := followUpAction;
                    AuditFindingAction."Follow Up Status" := followUpStatus;
                    AuditFindingAction."Action Effective?" := isEffective;
                    AuditFindingAction."Effectiveness Desc" := effectivenessDesc;
                    AuditFindingAction."Effectiveness Status" := effectivenessStatus;
                    AuditFindingAction.Insert;
                    return_value := true;
                end
                else
                    if type = 'edit' then begin
                        AuditFindingAction.SetRange(Code, findingActionCode);
                        if AuditFindingAction.Find('-') then begin
                            AuditFindingAction."Finding Code" := findingCode;
                            AuditFindingAction."Action Classification" := actionClassification;
                            AuditFindingAction."Review Area" := reviewArea;
                            AuditFindingAction."Requirement Desc 1" := requirement1;
                            AuditFindingAction."Requirement Desc 2" := requirement2;
                            AuditFindingAction."Evidence Desc 1" := evidence1;
                            AuditFindingAction."Evidence Desc 2" := evidence2;
                            AuditFindingAction."Evidence Desc 3" := evidence3;
                            AuditFindingAction."Root Cause" := rootCause;
                            AuditFindingAction."Correction Desc 1" := correction1;
                            AuditFindingAction."Correction Desc 2" := correction2;
                            AuditFindingAction."Correction Desc 3" := correction3;
                            AuditFindingAction."Correction Desc 4" := correction4;
                            AuditFindingAction."Recurrence action 1" := recurrence1;
                            AuditFindingAction."Recurrence action 2" := recurrence2;
                            if Format(completionDate) <> '01/01/1753' then completionDate := completionDate else completionDate := 0D;
                            AuditFindingAction."Completion Date" := completionDate;
                            AuditFindingAction."Action Appropriate?" := isAppropriate;
                            AuditFindingAction."Follow Up Action" := followUpAction;
                            AuditFindingAction."Follow Up Status" := followUpStatus;
                            AuditFindingAction."Action Effective?" := isEffective;
                            AuditFindingAction."Effectiveness Desc" := effectivenessDesc;
                            AuditFindingAction."Effectiveness Status" := effectivenessStatus;
                            AuditFindingAction.Modify;
                            return_value := true;
                        end;
                    end;
            end
            else begin
                return_value := true;
            end;
        end;
    end;



    procedure SendEmail(var receiver: Text[100]; subject: Text[50]; message: Text[500]) returnValue: Boolean
    var
        SMTPMail: Codeunit "Email Message";
        SendEmail: codeunit email;
        otherEmails: List of [Text];
    begin
        returnValue := false;
        otherEmails.Add(receiver);

        SMTPMail.Create(otherEmails, COMPANYNAME, 'TEST', true);
        // SMTPMail.Create(COMPANYNAME, CompanyInfo."E-Mail", ReceipAdd,
        //'This is to inform you that: ' + DocNo, 'Employee Number ' + ' ' + DocNo + ' has  ' + Description + ' Effective from. ' + FORMAT("Date Of Leaving")
        //, TRUE);
        //  SMTPMail.AppendBody('<br>');
        SendEmail.Send(SMTPMail, Enum::"Email Scenario"::Default);
        returnValue := true;
    end;

    procedure AuditProgrammeApproval("action": Integer; comments: Text[250]; programmeCode: Code[30]) return_value: Boolean
    begin
        return_value := false;
        AuditProgramme.Reset;
        AuditProgramme.SetRange(Code, programmeCode);
        if AuditProgramme.Find('-') then begin
            AuditProgramme.Status := action;
            AuditProgramme."Approval Comments" := comments;
            AuditProgramme.Modify;
            return_value := true;
        end;
    end;

    procedure AuditorApproval("action": Integer; comments: Text[250]; auditorCode: Code[30]) return_value: Boolean
    begin
        return_value := false;
        Auditors.Reset;
        Auditors.SetRange(Code, auditorCode);
        if Auditors.Find('-') then begin
            Auditors.Status := action;
            Auditors."Approval Comments" := comments;
            Auditors.Modify;
            return_value := true;
        end;
    end;

    procedure ReadNotification(notificationCode: Code[30]) return_value: Boolean
    begin
        return_value := false;
        AuditNotifications.Reset;
        AuditNotifications.SetRange(Code, notificationCode);
        if AuditNotifications.Find('-') then begin
            AuditNotifications."Read?" := true;
            AuditNotifications.Modify;
            return_value := true;
        end;
    end;

    procedure Risk(riskCode: Code[30]; department: Code[30]; riskDesc1: Text[250]; riskDesc2: Text[250]; riskDesc3: Text[250]; riskDesc4: Text[250]; indicator1: Text[250]; indicator2: Text[250]; environment: Integer; level: Integer; likelihood: Integer; impact: Integer; createdBy: Code[20]; actionType: Text) return_value: Boolean
    begin
        return_value := true;
        Risks.Reset;
        if actionType = 'new' then begin
            Risks.Init;
            NextNo := NoSeriesMgt.GetNextNo('RISK', 0D, true);
            Risks.Code := NextNo;
            Risks.Department := department;
            Risks."Risk Desc 1" := riskDesc1;
            Risks."Risk Desc 2" := riskDesc2;
            Risks."Risk Desc 3" := riskDesc3;
            Risks."Risk Desc 4" := riskDesc4;
            Risks."Indicator Desc 1" := indicator1;
            Risks."Indicator Desc 2" := indicator2;
            Risks.Environment := environment;
            Risks.Impact := impact;
            Risks.Likelihood := likelihood;
            Risks.Level := level;
            Risks."Date Created" := Today;
            Risks."Created By" := createdBy;
            Risks.Insert;
            return_value := true;
        end
        else
            if actionType = 'edit' then begin
                Risks.SetRange(Code, riskCode);
                if Risks.Find('-') then begin
                    Risks.Department := department;
                    Risks."Risk Desc 1" := riskDesc1;
                    Risks."Risk Desc 2" := riskDesc2;
                    Risks."Risk Desc 3" := riskDesc3;
                    Risks."Risk Desc 4" := riskDesc4;
                    Risks."Indicator Desc 1" := indicator1;
                    Risks."Indicator Desc 2" := indicator2;
                    Risks.Environment := environment;
                    Risks.Impact := impact;
                    Risks.Likelihood := likelihood;
                    Risks.Level := level;
                    Risks."Date Created" := Today;
                    Risks."Created By" := createdBy;
                    Risks.Modify;
                    return_value := true;
                end;
            end;
    end;

    procedure DeleteRisk(riskCode: Code[10]) return_value: Boolean
    begin
        return_value := false;
        Risks.Reset;
        Risks.SetRange(Code, riskCode);
        if Risks.Find('-') then begin
            Risks.Delete;
            return_value := true;
        end;
    end;

    procedure UpdateCheckpointFinding(checkpointCode: Code[30]; description1: Text[250]; description2: Text[250]; description3: Text[250]; description4: Text[250]; citation1: Text[250]; citation2: Text[250]) return_value: Boolean
    begin
        return_value := false;
        AuditCheckpoint.Reset;
        AuditCheckpoint.SetRange(Code, checkpointCode);
        if AuditCheckpoint.Find('-') then begin
            AuditCheckpoint."Finding Desc 1" := description1;
            AuditCheckpoint."Finding Desc 2" := description2;
            AuditCheckpoint."Finding Desc 3" := description3;
            AuditCheckpoint."Finding Desc 4" := description4;
            AuditCheckpoint."Finding Citation 1" := citation1;
            AuditCheckpoint."Finding Citation 2" := citation2;
            AuditCheckpoint."Finding Status" := AuditCheckpoint."finding status"::"Pending submission";
            AuditCheckpoint.Modify;
            return_value := true;
        end;
    end;

    procedure SubmitFinding(checkpointCode: Code[20]) return_value: Boolean
    begin
        Checklists.Reset;
        Checklists.SetRange(Code, checkpointCode);
        if Checklists.Find('-') then begin
            Checklists."Finding Status" := Checklists."finding status"::"Pending Acceptance";
            Checklists.Modify;
        end;
    end;

    procedure AuditFindingApproval("action": Integer; comments: Text[250]; findingCode: Code[30]) return_value: Boolean
    begin
        return_value := false;
        Checklists.Reset;
        Checklists.SetRange(Code, findingCode);
        if Checklists.Find('-') then begin
            Checklists."Approval Comments" := comments;
            if action = 4 then begin
                Checklists."Rejected Count" := Checklists."Rejected Count" + 1;
                Checklists."Finding Status" := Checklists."finding status"::Rejected;
            end
            else begin
                Checklists."Finding Status" := Checklists."finding status"::Accepted;
            end;
            Checklists.Modify;
            return_value := true;
        end;
    end;

    procedure CloseOpenAudit(auditCode: Code[20]; status: Integer) return_value: Boolean
    begin
        return_value := false;
        Audits.Reset;
        Audits.SetRange(Code, auditCode);
        if Audits.Find('-') then begin
            Audits.Status := status;
            Audits.Modify;
            return_value := true;
        end;
    end;

    procedure PreventiveActionForm(findingActionCode: Code[20]; actionClassification: Integer; findingClassification: Integer; type: Text; findingCode: Code[20]; reviewArea: Text[250]; requirement1: Text[250]; requirement2: Text[250]; evidence1: Text[250]; evidence2: Text[250]; evidence3: Text[250]; rootCause: Text[250]; correction1: Text[250]; correction2: Text[250]; correction3: Text[250]; correction4: Text[250]; recurrence1: Text[250]; recurrence2: Text[250]; completionDate: Date; isAppropriate: Boolean; followUpAction: Text[250]; followUpStatus: Integer; isEffective: Boolean; effectivenessDesc: Text[250]; effectivenessStatus: Boolean) return_value: Boolean
    begin
        return_value := false;
        AuditFinding.Reset;
        AuditFinding.SetRange(Code, findingCode);
        if AuditFinding.Find('-') then begin
            AuditFinding.Classification := findingClassification;
            AuditFinding.Modify;
            if (AuditFinding.Classification) <> (AuditFinding.Classification::"Compliance/Positive") then begin
                AuditFindingAction.Reset;
                if type = 'new' then begin
                    AuditFindingAction.Init;
                    NextNo := NoSeriesMgt.GetNextNo('AUDTFA', 0D, true);
                    AuditFindingAction.Code := NextNo;
                    AuditFindingAction."Finding Code" := findingCode;
                    AuditFindingAction."Action Classification" := actionClassification;
                    AuditFindingAction."Review Area" := reviewArea;
                    AuditFindingAction."Requirement Desc 1" := requirement1;
                    AuditFindingAction."Requirement Desc 2" := requirement2;
                    AuditFindingAction."Evidence Desc 1" := evidence1;
                    AuditFindingAction."Evidence Desc 2" := evidence2;
                    AuditFindingAction."Evidence Desc 3" := evidence3;
                    AuditFindingAction."Root Cause" := rootCause;
                    AuditFindingAction."Correction Desc 1" := correction1;
                    AuditFindingAction."Correction Desc 2" := correction2;
                    AuditFindingAction."Correction Desc 3" := correction3;
                    AuditFindingAction."Correction Desc 4" := correction4;
                    AuditFindingAction."Recurrence action 1" := recurrence1;
                    AuditFindingAction."Recurrence action 2" := recurrence2;
                    if Format(completionDate) <> '01/01/1753' then completionDate := completionDate else completionDate := 0D;
                    AuditFindingAction."Completion Date" := completionDate;
                    AuditFindingAction."Action Appropriate?" := isAppropriate;
                    AuditFindingAction."Follow Up Action" := followUpAction;
                    AuditFindingAction."Follow Up Status" := followUpStatus;
                    AuditFindingAction."Action Effective?" := isEffective;
                    AuditFindingAction."Effectiveness Desc" := effectivenessDesc;
                    AuditFindingAction."Effectiveness Status" := effectivenessStatus;
                    AuditFindingAction.Insert;
                    return_value := true;
                end
                else
                    if type = 'edit' then begin
                        AuditFindingAction.SetRange(Code, findingActionCode);
                        if AuditFindingAction.Find('-') then begin
                            AuditFindingAction."Finding Code" := findingCode;
                            AuditFindingAction."Action Classification" := actionClassification;
                            AuditFindingAction."Review Area" := reviewArea;
                            AuditFindingAction."Requirement Desc 1" := requirement1;
                            AuditFindingAction."Requirement Desc 2" := requirement2;
                            AuditFindingAction."Evidence Desc 1" := evidence1;
                            AuditFindingAction."Evidence Desc 2" := evidence2;
                            AuditFindingAction."Evidence Desc 3" := evidence3;
                            AuditFindingAction."Root Cause" := rootCause;
                            AuditFindingAction."Correction Desc 1" := correction1;
                            AuditFindingAction."Correction Desc 2" := correction2;
                            AuditFindingAction."Correction Desc 3" := correction3;
                            AuditFindingAction."Correction Desc 4" := correction4;
                            AuditFindingAction."Recurrence action 1" := recurrence1;
                            AuditFindingAction."Recurrence action 2" := recurrence2;
                            if Format(completionDate) <> '01/01/1753' then completionDate := completionDate else completionDate := 0D;
                            AuditFindingAction."Completion Date" := completionDate;
                            AuditFindingAction."Action Appropriate?" := isAppropriate;
                            AuditFindingAction."Follow Up Action" := followUpAction;
                            AuditFindingAction."Follow Up Status" := followUpStatus;
                            AuditFindingAction."Action Effective?" := isEffective;
                            AuditFindingAction."Effectiveness Desc" := effectivenessDesc;
                            AuditFindingAction."Effectiveness Status" := effectivenessStatus;
                            AuditFindingAction.Modify;
                            return_value := true;
                        end;
                    end;
            end
            else begin
                return_value := true;
            end;
        end;
    end;

    procedure PositiveClassification(findingCode: Code[20]; status: Integer) return_value: Boolean
    begin
        return_value := false;
        AuditFinding.Reset;
        AuditFinding.SetRange(Code, findingCode);
        if AuditFinding.Find('-') then begin
            AuditFinding.Classification := status;
            AuditFinding.Modify;
            return_value := true;
        end;
    end;

    procedure RiskControl(riskCode: Code[20]; description1: Text[250]; description2: Text[250]; description3: Text[250]; description4: Text[250]; actionType: Text; createdBy: Code[20]; controlCode: Code[20]) return_value: Boolean
    begin
        return_value := false;
        RiskControls.Reset;
        if actionType = 'new' then begin
            RiskControls.Init;
            NextNo := NoSeriesMgt.GetNextNo('RISKC', 0D, true);
            RiskControls.Code := NextNo;
            RiskControls."Risk Code" := riskCode;
            RiskControls."Control Desc 1" := description1;
            RiskControls."Control Desc 2" := description2;
            RiskControls."Control Desc 3" := description3;
            RiskControls."Control Desc 4" := description4;
            RiskControls."Date Created" := Today;
            RiskControls."Created By" := createdBy;
            RiskControls.Insert;
            return_value := true;
        end
        else
            if actionType = 'edit' then begin
                RiskControls.SetRange(Code, controlCode);
                if RiskControls.Find('-') then begin
                    RiskControls."Control Desc 1" := description1;
                    RiskControls."Control Desc 2" := description2;
                    RiskControls."Control Desc 3" := description3;
                    RiskControls."Control Desc 4" := description4;
                    RiskControls."Date Edited" := Today;
                    RiskControls."Edited By" := createdBy;
                    RiskControls.Modify;
                    return_value := true;
                end;
            end;
    end;

    procedure DeleteRiskControl(controlCode: Code[20]) return_value: Boolean
    begin
        return_value := false;
        RiskControls.Reset;
        RiskControls.SetRange(Code, controlCode);
        if RiskControls.Find('-') then begin
            RiskControls.Delete;
            return_value := true;
        end;
    end;

    procedure RiskMitigation(riskCode: Code[20]; description1: Text[250]; description2: Text[250]; description3: Text[250]; description4: Text[250]; actionType: Text; createdBy: Code[20]; mitigationCode: Code[20]) return_value: Boolean
    begin
        return_value := false;
        RiskMitigations.Reset;
        if actionType = 'new' then begin
            RiskMitigations.Init;
            NextNo := NoSeriesMgt.GetNextNo('RISKM', 0D, true);
            RiskMitigations.Code := NextNo;
            RiskMitigations."Risk Code" := riskCode;
            RiskMitigations."Mitigation Desc 1" := description1;
            RiskMitigations."Mitigation Desc 2" := description2;
            RiskMitigations."Mitigation Desc 3" := description3;
            RiskMitigations."Mitigation Desc 4" := description4;
            RiskMitigations."Date Created" := Today;
            RiskMitigations."Created By" := createdBy;
            RiskMitigations.Insert;
            return_value := true;
        end
        else
            if actionType = 'edit' then begin
                RiskMitigations.SetRange(Code, mitigationCode);
                if RiskMitigations.Find('-') then begin
                    RiskMitigations."Mitigation Desc 1" := description1;
                    RiskMitigations."Mitigation Desc 2" := description2;
                    RiskMitigations."Mitigation Desc 3" := description3;
                    RiskMitigations."Mitigation Desc 4" := description4;
                    RiskMitigations."Date Edited" := Today;
                    RiskMitigations."Edited By" := createdBy;
                    RiskMitigations.Modify;
                    return_value := true;
                end;
            end;
    end;

    procedure DeleteRiskMitigation(mitigationCode: Code[20]) return_value: Boolean
    begin
        return_value := false;
        RiskMitigations.Reset;
        RiskMitigations.SetRange(Code, mitigationCode);
        if RiskMitigations.Find('-') then begin
            RiskMitigations.Delete;
            return_value := true;
        end;
    end;

    procedure ResidualRisk(riskCode: Code[30]; residualRiskCode: Code[30]; riskDesc1: Text[250]; riskDesc2: Text[250]; riskDesc3: Text[250]; riskDesc4: Text[250]; indicator1: Text[250]; indicator2: Text[250]; level: Integer; likelihood: Integer; impact: Integer; createdBy: Code[20]; actionType: Text; environment: Integer; department: Code[20]; mitigation1: Text[250]; mitigation2: Text[250]; mitigation3: Text[250]; mitigation4: Text[250]) return_value: Boolean
    begin
        return_value := false;
        ResidualRisks.Reset;
        if actionType = 'new' then begin
            ResidualRisks.Init;
            NextNo := NoSeriesMgt.GetNextNo('RISKR', 0D, true);
            ResidualRisks.Code := NextNo;
            ResidualRisks."Risk Code" := riskCode;
            ResidualRisks."Risk Desc 1" := riskDesc1;
            ResidualRisks."Risk Desc 2" := riskDesc2;
            ResidualRisks."Risk Desc 3" := riskDesc3;
            ResidualRisks."Risk Desc 4" := riskDesc4;
            ResidualRisks."Indicator Desc 1" := indicator1;
            ResidualRisks."Indicator Desc 2" := indicator2;
            ResidualRisks.Impact := impact;
            ResidualRisks.Likelihood := likelihood;
            ResidualRisks.Level := level;
            ResidualRisks."Date Created" := Today;
            ResidualRisks."Created By" := createdBy;
            ResidualRisks.Environment := environment;
            ResidualRisks.Department := department;
            ResidualRisks."Mitigation Desc 1" := mitigation1;
            ResidualRisks."Mitigation Desc 2" := mitigation2;
            ResidualRisks."Mitigation Desc 3" := mitigation3;
            ResidualRisks."Mitigation Desc 4" := mitigation4;
            ResidualRisks.Insert;
            return_value := true;
        end
        else
            if actionType = 'edit' then begin
                ResidualRisks.SetRange(Code, residualRiskCode);
                if ResidualRisks.Find('-') then begin
                    ResidualRisks."Risk Desc 1" := riskDesc1;
                    ResidualRisks."Risk Desc 2" := riskDesc2;
                    ResidualRisks."Risk Desc 3" := riskDesc3;
                    ResidualRisks."Risk Desc 4" := riskDesc4;
                    ResidualRisks."Indicator Desc 1" := indicator1;
                    ResidualRisks."Indicator Desc 2" := indicator2;
                    ResidualRisks.Impact := impact;
                    ResidualRisks.Likelihood := likelihood;
                    ResidualRisks.Environment := environment;
                    ResidualRisks.Department := department;
                    ResidualRisks."Mitigation Desc 1" := mitigation1;
                    ResidualRisks."Mitigation Desc 2" := mitigation2;
                    ResidualRisks."Mitigation Desc 3" := mitigation3;
                    ResidualRisks."Mitigation Desc 4" := mitigation4;
                    ResidualRisks.Level := level;
                    ResidualRisks."Date Created" := Today;
                    ResidualRisks."Created By" := createdBy;
                    ResidualRisks.Modify;
                    return_value := true;
                end;
            end;
    end;

    procedure DeleteResidualRisk(residualRiskCode: Code[10]) return_value: Boolean
    begin
        return_value := false;
        ResidualRisks.Reset;
        ResidualRisks.SetRange(Code, residualRiskCode);
        if ResidualRisks.Find('-') then begin
            ResidualRisks.Delete;
            return_value := true;
        end;
    end;

    procedure RiskIncidence(riskCode: Code[30]; incidenceCode: Code[30]; description1: Text[250]; description2: Text[250]; description3: Text[250]; description4: Text[250]; createdBy: Code[20]; actionType: Text) return_value: Boolean
    begin
        return_value := false;
        RiskIncidences.Reset;
        if actionType = 'new' then begin
            RiskIncidences.Init;
            NextNo := NoSeriesMgt.GetNextNo('RISKI', 0D, true);
            RiskIncidences.Code := NextNo;
            RiskIncidences."Risk Code" := riskCode;
            RiskIncidences."Incidence Desc 1" := description1;
            RiskIncidences."Incidence Desc 2" := description2;
            RiskIncidences."Incidence Desc 3" := description3;
            RiskIncidences."Incidence Desc 4" := description4;
            RiskIncidences."Date Created" := Today;
            RiskIncidences."Created By" := createdBy;
            RiskIncidences.Insert;
            return_value := true;
        end
        else
            if actionType = 'edit' then begin
                RiskIncidences.SetRange(Code, incidenceCode);
                if RiskIncidences.Find('-') then begin
                    RiskIncidences."Incidence Desc 1" := description1;
                    RiskIncidences."Incidence Desc 2" := description2;
                    RiskIncidences."Incidence Desc 3" := description3;
                    RiskIncidences."Incidence Desc 4" := description4;
                    RiskIncidences.Modify;
                    return_value := true;
                end;
            end;
    end;

    procedure DeleteRiskIncidence(incidenceCode: Code[10]) return_value: Boolean
    begin
        return_value := false;
        RiskIncidences.Reset;
        RiskIncidences.SetRange(Code, incidenceCode);
        if RiskIncidences.Find('-') then begin
            RiskIncidences.Delete;
            return_value := true;
        end;
    end;

    procedure InsertLinks("code": Code[20]; description: Text[200]; url: Text[200]; tableNo: Integer; fieldId: Integer) return_value: Boolean
    var
        RecordRef1: RecordRef;
        RecordID: RecordID;
        RecordLink: Record "Record Link";
        FieldRef: FieldRef;
    begin
        RecordRef1.Open(tableNo);
        FieldRef := RecordRef1.Field(fieldId);
        FieldRef.Value := code;
        if RecordRef1.Find('=') then begin
            RecordID := RecordRef1.RecordId;
            RecordLink.Reset;
            RecordLink."Record ID" := RecordID;
            RecordLink.URL1 := url;
            RecordLink.Type := RecordLink.Type::Link;
            RecordLink.Company := 'UNIVERSITY';
            RecordLink."User ID" := UserId;
            RecordLink.Created := CurrentDatetime;
            RecordLink.Description := description;
            RecordLink.Insert;
        end;
    end;

    procedure Archive("code": Code[20]; title: Text[50]; description: Text[250]; createdBy: Code[20]; actionType: Text) return_value: Code[20]
    begin
        return_value := '';
        QMSArchive.Reset;
        if actionType = 'new' then begin
            QMSArchive.Init;
            NextNo := NoSeriesMgt.GetNextNo('QMSAR', 0D, true);
            QMSArchive.Code := NextNo;
            QMSArchive.Title := title;
            QMSArchive.Description := description;
            QMSArchive."Date Created" := Today;
            QMSArchive."Created By" := createdBy;
            QMSArchive.Insert;
            return_value := NextNo;
        end
        else
            if actionType = 'edit' then begin
                QMSArchive.SetRange(Code, code);
                if QMSArchive.Find('-') then begin
                    QMSArchive.Title := title;
                    QMSArchive.Description := description;
                    QMSArchive.Modify;
                    return_value := code;
                end;
            end;
    end;

    procedure DeleteArchiveItem("code": Code[10]) return_value: Boolean
    begin
        return_value := false;
        QMSArchive.Reset;
        QMSArchive.SetRange(Code, code);
        if QMSArchive.Find('-') then begin
            QMSArchive.Delete;
            return_value := true;
        end;
    end;

    procedure SaveEmail(subject: Text[250]; receiver: Text[100]; messageDesc1: Text[250]; messageDesc2: Text[250]; messageDesc3: Text[250]; messageDesc4: Text[250]; category: Integer; sender: Code[100]) return_value: Boolean
    var
        EmailSender: Record "Email Sender";
    begin
        return_value := false;
        EmailSender.Reset;
        EmailSender.Init;
        NextNo := NoSeriesMgt.GetNextNo('EML', 0D, true);
        EmailSender.Code := NextNo;
        EmailSender.Subject := subject;
        EmailSender."Receiver Email" := receiver;
        EmailSender."Message Desc 1" := messageDesc1;
        EmailSender."Message Desc 2" := messageDesc2;
        EmailSender."Message Desc 3" := messageDesc3;
        EmailSender."Message Desc 4" := messageDesc4;
        EmailSender.Category := category;
        EmailSender."Sent?" := false;
        EmailSender."Date Created" := CreateDatetime(Today, Time);
        EmailSender.Sender := sender;
        EmailSender.Insert;
        return_value := true;
    end;

    procedure SendEmails()
    var
        EmailSender: Record "Email Sender";
        message: Text[1000];
        isSent: Boolean;
        UserSetup: Record "User Setup";
    begin
        EmailSender.Reset;
        EmailSender.SetRange("Sent?", false);
        if EmailSender.Find('-') then begin
            repeat
                if EmailSender.Category <> EmailSender.Category::"Audit Notification" then begin
                    message := EmailSender."Message Desc 1" + EmailSender."Message Desc 2" + EmailSender."Message Desc 3" + EmailSender."Message Desc 4";
                    isSent := SendEmail(EmailSender."Receiver Email", EmailSender.Subject, message);
                end
                else
                    if EmailSender.Category = EmailSender.Category::"Audit Notification" then begin
                        UserSetup.Reset;
                        repeat
                            if UserSetup."E-Mail" <> '' then begin
                                message := EmailSender."Message Desc 1" + EmailSender."Message Desc 2" + EmailSender."Message Desc 3" + EmailSender."Message Desc 4";
                                isSent := SendEmail(UserSetup."E-Mail", EmailSender.Subject, message);
                            end;
                        until UserSetup.Next = 0;
                    end;
                if isSent = true then begin
                    EmailSender."Sent?" := true;
                    EmailSender.Modify;
                end;
            until EmailSender.Next = 0;
        end;
    end;

    procedure UserRole(userId: Code[30]; email: Text; isAuditor: Boolean; isPO: Boolean; isMR: Boolean; isVC: Boolean; isAdmin: Boolean) return_value: Boolean
    var
        UserSetup: Record "User Setup";
    begin
        return_value := false;
        UserSetup.Reset;
        UserSetup.Init;
        UserSetup.SetRange("User ID", userId);
        if UserSetup.Find('-') then begin
            UserSetup."QMS Auditor?" := isAuditor;
            UserSetup."QMS PO?" := isPO;
            UserSetup."QMS MR?" := isMR;
            UserSetup."QMS VC?" := isVC;
            UserSetup."QMS Admin?" := isAdmin;
            UserSetup."E-Mail" := email;
            UserSetup.Modify;
            return_value := true;
        end;
    end;




    procedure GenerateAuditorReport(programme: Code[20]; auditCode: Code[20]; auditor: Code[20]; filenameFromApp: Text) return_value: Boolean
    var
        Auditors: Record "Auditors";
        GeneralSetup: Record "General Set-Up";
    begin
        GeneralSetup.get;
        filename := GeneralSetup."Portal Reports File Path" + filenameFromApp;
        return_value := false;

        //REPORT.
        if Exists(filename) then
            Erase(filename);
        if programme <> '' then begin
            AuditProgramme.Reset;
            AuditProgramme.SetFilter(AuditProgramme.Code, programme);
            AuditorReport.SetTableview(AuditProgramme)
        end;
        if auditCode <> '' then begin
            Audits.Reset;
            Audits.SetRange(Code, auditCode);
            AuditorReport.SetTableview(Audits)
        end;
        if auditor <> '' then begin
            Auditors.Reset;
            Auditors.SetFilter("Code", auditor);
            AuditorReport.SetTableview(Auditors)
        end;
        AuditorReport.SaveAsPdf(filename);
        if not Exists(filename) then
            Error('No data found that match the filter criteria');
        return_value := true;
    end;

    procedure GenerateAuditReport(programme: Code[20]; auditCode: Code[20]; department: Code[20]; filenameFromApp: Text) return_value: Boolean
    var
        DimensionValue: Record "Dimension Value";
        GeneralSetup: Record "General Set-Up";
    begin
        GeneralSetup.get;
        filename := GeneralSetup."Portal Reports File Path" + filenameFromApp;
        return_value := false;

        //REPORT.
        if Exists(filename) then
            Erase(filename);
        if programme <> '' then begin
            AuditProgramme.Reset;
            AuditProgramme.SetFilter(AuditProgramme.Code, programme);
            AuditReport.SetTableview(AuditProgramme)
        end;
        if auditCode <> '' then begin
            Audits.Reset;
            Audits.SetRange(Code, auditCode);
            AuditReport.SetTableview(Audits)
        end;
        if department <> '' then begin
            DimensionValue.Reset;
            DimensionValue.SetRange("Dimension Code", 'DEPARTMENT');
            DimensionValue.SetRange(Code, department);
            AuditReport.SetTableview(DimensionValue)
        end;
        AuditReport.SaveAsPdf(filename);
        if not Exists(filename) then
            Error('No data found that match the filter criteria');
        return_value := true;
    end;

    procedure GenerateRiskReport(searchDate: Text; department: Code[20]; filenameFromApp: Text) return_value: Boolean
    var
        GeneralSetup: Record "General Set-Up";
    begin
        GeneralSetup.get;
        filename := GeneralSetup."Portal Reports File Path" + filenameFromApp;
        return_value := false;

        //REPORT.
        if Exists(filename) then
            Erase(filename);
        if searchDate <> '' then begin
            Risks.Reset;
            Risks.SetFilter(Risks."Date Created", searchDate);
            RiskReport.SetTableview(Risks)
        end;
        if department <> '' then begin
            DimensionValues.Reset;
            DimensionValues.SetRange("Dimension Code", 'DEPARTMENT');
            DimensionValues.SetRange(Code, department);
            RiskReport.SetTableview(DimensionValues)
        end;
        if Risks.Count = 0 then begin
            Error('No data found that match the filter criteria.');
        end;
        RiskReport.SaveAsPdf(filename);
        return_value := true;
    end;

    procedure NotificationSent(programmeCode: Code[20]) return_value: Boolean
    begin
        return_value := false;
        AuditProgramme.Reset;
        AuditProgramme.SetRange(Code, programmeCode);
        if AuditProgramme.Find('-') then begin
            AuditProgramme."Notification Sent?" := true;
            AuditProgramme.Modify;
            return_value := true;
        end;
    end;

    procedure AuditConclusion(auditor: Code[20]; audit: Code[20]; conclusion1: text[200]; conclusion2: text[200]) return_value: Boolean
    begin
        return_value := false;
        Auditors.Reset;
        Auditors.SetRange(Auditors."Audit Code", audit);
        Auditors.SetRange(Auditors."User ID", auditor);
        if Auditors.Find('-') then begin
            Auditors.Conclusion1 := conclusion1;
            Auditors.Conclusion2 := conclusion2;
            Auditors.Modify;
            return_value := true;
        end;
    end;

    procedure NewAudit(auditProgramme: Code[30]; name: Text[250]; description: Text[250]; sequence: Integer; createdBy: Code[20]) return_value: Boolean
    begin
        return_value := false;
        Audits.Reset;
        Audits.SetRange("Audit Programme", auditProgramme);
        Audits.SetRange(Sequence, sequence);
        if Audits.Find('-') then begin
            return_value := false;
        end
        else begin
            Audits.Init;
            NextNo := NoSeriesMgt.GetNextNo('AUDT', 0D, true);
            Audits.Code := NextNo;
            Audits."Audit Programme" := auditProgramme;
            Audits.Name := name;
            Audits.Description := description;
            Audits.Sequence := sequence;
            Audits."Created By" := createdBy;
            Audits.Status := Audits.Status::Open;
            Audits."Date Created" := Today;
            Audits.Insert;
            return_value := true;
        end;
    end;

    procedure DeleteAudit(auditCode: Code[30]) return_value: Boolean
    begin
        return_value := false;
        Audits.Reset;
        Audits.SetRange(Code, auditCode);
        if Audits.Find('-') then begin
            Audits.Delete;
            return_value := true;
        end
        else begin
            Error('Unknown audit');
        end;
    end;



    procedure InsertAuditNofication(notificationCode: Code[20]; audit: Code[20]; programme: Code[20]; auditor: Code[20]; auditee: Code[20]; auditDate: Date; objectives1: Text[250]; objectives2: Text[250]; criteria1: Text[250]; criteria2: Text[250]; activities1: Text[250]; activities2: Text[250]; noSeries: Code[20]) return_value: Boolean
    var
        AuditNotification: Record "Audit Notifications";
    begin
        return_value := false;
        AuditNotification.reset;
        if notificationCode <> '' then begin
            AuditNotification.setrange("Code", notificationCode);
            if (AuditNotification.find('-')) THEN begin
                AuditNotification.Programme := programme;
                AuditNotification.Audit := audit;
                AuditNotification.Auditee := auditee;
                AuditNotification.Auditor := auditor;
                AuditNotification."Audit Date" := auditDate;
                AuditNotification.Objectives1 := objectives1;
                AuditNotification.Objectives2 := objectives2;
                AuditNotification.Criteria1 := criteria1;
                AuditNotification.Criteria2 := criteria2;
                AuditNotification.Activities1 := Activities1;
                AuditNotification.Activities2 := Activities2;
                AuditNotification.Modify;
                return_value := true;
            END;
        end else
            NextNo := NoSeriesMgt.GetNextNo(noSeries, 0D, true);
        AuditNotification."Code" := NextNo;
        AuditNotification.Programme := programme;
        AuditNotification.Audit := audit;
        AuditNotification.Auditee := auditee;
        AuditNotification.Auditor := auditor;
        AuditNotification."Audit Date" := auditDate;
        AuditNotification.Objectives1 := objectives1;
        AuditNotification.Objectives2 := objectives2;
        AuditNotification.Criteria1 := criteria1;
        AuditNotification.Criteria2 := criteria2;
        AuditNotification.Activities1 := Activities1;
        AuditNotification.Activities2 := Activities2;
        AuditNotification.Insert;
        return_value := true;
    end;
    // end;
}

