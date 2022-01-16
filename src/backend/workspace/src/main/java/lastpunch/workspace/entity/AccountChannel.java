package lastpunch.workspace.entity;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name="accountchannel")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AccountChannel{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(targetEntity= Account.class, fetch= FetchType.LAZY)
    @JoinColumn(name="accountid")
    private Account account;
    
    @ManyToOne(targetEntity=Channel.class, fetch = FetchType.LAZY)
    @JoinColumn(name="channelid")
    private Channel channel;
    
    // TODO: 채널 내 권한 (role) 관련 필드 추가
}
