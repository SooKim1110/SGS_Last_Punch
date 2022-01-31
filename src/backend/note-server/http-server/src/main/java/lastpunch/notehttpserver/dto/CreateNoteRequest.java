package lastpunch.notehttpserver.dto;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import javax.validation.constraints.NotNull;
import lastpunch.notehttpserver.entity.Note;
import lastpunch.notehttpserver.entity.Op;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

@Data
public class CreateNoteRequest {
    @NotNull
    private Long workspaceId;
    @NotNull
    private Long channelId;
    @NotNull
    private Long creatorId;
    
    public Note toEntity(){
        String defaultContent = "["
            + "{"
            + "\"type\": \"paragraph\","
            + "\"children\": [{ \"text\": \"\" }]"
            + "}"
            + "]";

        return Note.builder()
            .workspaceId(workspaceId)
            .channelId(channelId)
            .creatorId(creatorId)
            .title("Untitled")
            .content(defaultContent)
            .ops(new ArrayList<Op>())
            .createDt(LocalDateTime.now())
            .modifyDt(LocalDateTime.now())
            .build();
    }
}