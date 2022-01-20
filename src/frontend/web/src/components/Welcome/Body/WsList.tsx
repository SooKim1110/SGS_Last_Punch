import React, { useState, useEffect } from 'react';
import styled from 'styled-components';
import expand from '../../../icon/expand.svg';
import WsItem from './WsItem';
import { IWorkspace } from '../../../../types/workspace.type';
import { getWsListAPI } from '../../../Api/workspace';

const Container = styled.section`
  border: 4px solid rgba(255, 255, 255, 0.2);
  border-radius: 9px;
`;

const Box = styled.article`
  display: flex;
  flex-direction: column;

  & > * {
    padding: 16px;
  }
`;

const BoxHeader = styled.article`
  background: #ecdeec;
  border-top-left-radius: 5px;
  border-top-right-radius: 5px;
  font-size: 1.125rem;
`;

const BoxContent = styled.article`
  background: white;
  border-bottom-left-radius: 5px;
  border-bottom-right-radius: 5px;
`;

const ShowMore = styled.article`
  display: flex;
  justify-content: center;
  align-items: center;
  height: 54px;
  margin: -16px;
  margin-top: 34px;
`;

const ShowMoreButton = styled.button`
  color: #1264a3;
  font-size: 14px;
  background: none;
  border: none;
  cursor: pointer;
  display: flex;
`;

const ShowMoreIcon = styled.div`
  &::after {
    display: block;
    content: '';
    height: 15px;
    width: 15px;
    background-image: url(${expand});
    background-repeat: no-repeat;
    margin-left: 4px;
  }
`;

export default function WsList() {
  const [wsList, setWsList] = useState([]);

  const getWsList = async () => {
    const { workspaces } = await getWsListAPI('1'); // dummy userId
    if (workspaces) setWsList(workspaces.content);
    else alert('error');
  };

  useEffect(() => {
    getWsList();
  }, []);

  return (
    <Container>
      <Box>
        <BoxHeader>워크스페이스 목록</BoxHeader>
        <BoxContent>
          {wsList.map((ws: IWorkspace) => (
            <WsItem ws={ws} key={ws.id}></WsItem>
          ))}
          <ShowMore>
            <ShowMoreButton>
              <span>더 보기</span>
              <ShowMoreIcon></ShowMoreIcon>
            </ShowMoreButton>
          </ShowMore>
        </BoxContent>
      </Box>
    </Container>
  );
}
